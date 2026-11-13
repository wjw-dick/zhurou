package com.zhushi.common.core;

import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.baomidou.mybatisplus.core.metadata.IPage;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.baomidou.mybatisplus.extension.service.IService;
import com.zhushi.common.security.PermChecker;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestParam;

import java.util.List;
import java.util.Map;
import java.util.regex.Pattern;

/**
 * 通用 CRUD 基类。
 * 超级管理员（superAdmin）在 PermChecker 中一律放行，因此「超管对任何功能均可维护」。
 * 子类只需声明 service 与权限前缀，可按需覆写 buildQuery 扩展查询条件。
 */
public abstract class BaseController<S extends IService<T>, T extends BaseEntity> {

    /** 只允许字母、数字、下划线，防止排序字段注入 */
    private static final Pattern SAFE_FIELD = Pattern.compile("^[A-Za-z0-9_]+$");

    protected final PermChecker permChecker;

    protected BaseController(PermChecker permChecker) {
        this.permChecker = permChecker;
    }

    protected abstract S service();

    /** 权限前缀，如 sys:user → sys:user:list / sys:user:add / sys:user:edit / sys:user:del */
    protected abstract String permPrefix();

    /** keyword 模糊匹配的字段 */
    protected String[] searchFields() {
        return new String[]{"name"};
    }

    /** 子类扩展查询条件 */
    protected void buildQuery(Map<String, String> params, QueryWrapper<T> wrapper) {
    }

    /** 列表查询是否需要 list 权限 */
    protected boolean requireReadPerm() {
        return true;
    }

    @GetMapping("/page")
    public R<PageResult<T>> page(@RequestParam Map<String, String> params) {
        if (requireReadPerm()) {
            permChecker.require(permPrefix() + ":list");
        }
        long current = parseLong(params.get("current"), 1L);
        long size = Math.min(parseLong(params.get("size"), 10L), 500L);
        QueryWrapper<T> wrapper = new QueryWrapper<>();
        String keyword = params.get("keyword");
        String[] fields = searchFields();
        if (keyword != null && !keyword.isBlank() && fields != null && fields.length > 0) {
            wrapper.and(w -> {
                for (int i = 0; i < fields.length; i++) {
                    if (i == 0) {
                        w.like(fields[i], keyword);
                    } else {
                        w.or().like(fields[i], keyword);
                    }
                }
            });
        }
        buildQuery(params, wrapper);
        applySort(params, wrapper);
        IPage<T> page = service().page(new Page<>(current, size), wrapper);
        return R.ok(PageResult.of(page));
    }

    @GetMapping("/list")
    public R<List<T>> list(@RequestParam Map<String, String> params) {
        if (requireReadPerm()) {
            permChecker.require(permPrefix() + ":list");
        }
        QueryWrapper<T> wrapper = new QueryWrapper<>();
        buildQuery(params, wrapper);
        applySort(params, wrapper);
        return R.ok(service().list(wrapper));
    }

    @GetMapping("/{id}")
    public R<T> info(@PathVariable Long id) {
        if (requireReadPerm()) {
            permChecker.require(permPrefix() + ":list");
        }
        return R.ok(service().getById(id));
    }

    @PostMapping
    public R<Long> save(@RequestBody T entity) {
        permChecker.require(permPrefix() + ":add");
        beforeSave(entity);
        service().save(entity);
        afterSave(entity);
        return R.ok(entity.getId());
    }

    @PutMapping
    public R<Void> update(@RequestBody T entity) {
        permChecker.require(permPrefix() + ":edit");
        beforeUpdate(entity);
        service().updateById(entity);
        return R.ok();
    }

    @DeleteMapping("/{id}")
    public R<Void> remove(@PathVariable Long id) {
        permChecker.require(permPrefix() + ":del");
        service().removeById(id);
        return R.ok();
    }

    @DeleteMapping("/batch")
    public R<Void> removeBatch(@RequestBody List<Long> ids) {
        permChecker.require(permPrefix() + ":del");
        service().removeByIds(ids);
        return R.ok();
    }

    protected void beforeSave(T entity) {
    }

    protected void afterSave(T entity) {
    }

    protected void beforeUpdate(T entity) {
    }

    protected void applySort(Map<String, String> params, QueryWrapper<T> wrapper) {
        String orderBy = params.get("orderBy");
        if (orderBy == null || !SAFE_FIELD.matcher(orderBy).matches()) {
            return;
        }
        boolean asc = !"desc".equalsIgnoreCase(params.getOrDefault("orderDir", "asc"));
        wrapper.orderBy(true, asc, orderBy);
    }

    protected long parseLong(String value, long def) {
        try {
            return value == null ? def : Long.parseLong(value);
        } catch (NumberFormatException e) {
            return def;
        }
    }

    protected Integer parseInt(String value) {
        try {
            return value == null ? null : Integer.parseInt(value);
        } catch (NumberFormatException e) {
            return null;
        }
    }
}
