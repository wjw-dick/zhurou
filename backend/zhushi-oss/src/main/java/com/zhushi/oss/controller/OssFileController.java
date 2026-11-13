package com.zhushi.oss.controller;

import com.zhushi.common.annotation.OperationLog;
import com.zhushi.common.annotation.RequiresPerm;
import com.zhushi.common.core.BaseController;
import com.zhushi.common.core.R;
import com.zhushi.common.security.PermChecker;
import com.zhushi.oss.entity.OssFile;
import com.zhushi.oss.service.OssFileService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.util.Map;

/**
 * 文件上传（图片上传组件 / 富文本 WangEditor 5 图片统一走这里）
 */
@Tag(name = "文件上传")
@RestController
@RequestMapping("/oss/file")
public class OssFileController extends BaseController<OssFileService, OssFile> {

    private final OssFileService ossFileService;

    public OssFileController(OssFileService ossFileService, PermChecker permChecker) {
        super(permChecker);
        this.ossFileService = ossFileService;
    }

    @Override
    protected OssFileService service() {
        return ossFileService;
    }

    @Override
    protected String permPrefix() {
        return "oss:config";
    }

    @Override
    protected String[] searchFields() {
        return new String[]{"file_name", "biz_type"};
    }

    @Override
    protected void buildQuery(Map<String, String> params, com.baomidou.mybatisplus.core.conditions.query.QueryWrapper<OssFile> wrapper) {
        wrapper.eq(params.get("bizType") != null && !params.get("bizType").isBlank(), "biz_type", params.get("bizType"))
                .orderByDesc("id");
    }

    /** 单文件上传 */
    @Operation(summary = "上传文件")
    @OperationLog(module = "文件上传", action = "上传")
    @RequiresPerm("")
    @PostMapping("/upload")
    public R<OssFile> upload(@RequestParam("file") MultipartFile file,
                             @RequestParam(required = false) String bizType) {
        return R.ok(ossFileService.upload(file, bizType));
    }

    /** 多图上传 */
    @Operation(summary = "批量上传")
    @OperationLog(module = "文件上传", action = "批量上传")
    @RequiresPerm("")
    @PostMapping("/uploadBatch")
    public R<java.util.List<OssFile>> uploadBatch(@RequestParam("files") MultipartFile[] files,
                                                  @RequestParam(required = false) String bizType) {
        java.util.List<OssFile> list = new java.util.ArrayList<>();
        for (MultipartFile file : files) {
            list.add(ossFileService.upload(file, bizType));
        }
        return R.ok(list);
    }

    /** 删除文件 */
    @OperationLog(module = "文件上传", action = "删除")
    @RequiresPerm("")
    @DeleteMapping("/remove")
    public R<Void> remove(@RequestParam String path) {
        ossFileService.deleteByPath(path);
        return R.ok();
    }
}
