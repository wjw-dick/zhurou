package com.zhushi.product.service;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.zhushi.common.exception.BizException;
import com.zhushi.product.entity.Product;
import com.zhushi.product.entity.ProductQualification;
import com.zhushi.product.entity.ProductSku;
import com.zhushi.product.mapper.ProductMapper;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDate;
import java.util.List;

/**
 * 商品服务：含 SKU / 检疫资质 级联保存与上架合规校验
 */
@Service
@RequiredArgsConstructor
public class ProductService extends ServiceImpl<ProductMapper, Product> {

    private final ProductSkuService skuService;
    private final ProductQualificationService qualificationService;

    public List<ProductSku> skus(Long productId) {
        return skuService.list(new LambdaQueryWrapper<ProductSku>().eq(ProductSku::getProductId, productId));
    }

    public List<ProductQualification> qualifications(Long productId) {
        return qualificationService.list(new LambdaQueryWrapper<ProductQualification>()
                .eq(ProductQualification::getProductId, productId));
    }

    /** 上架前合规校验：猪肉需检疫证明、肉制品需 SC */
    public void checkSellable(Long productId) {
        Product product = getById(productId);
        if (product == null) {
            throw new BizException("商品不存在");
        }
        List<ProductQualification> quals = qualifications(productId);
        boolean valid = quals.stream().anyMatch(q -> Integer.valueOf(1).equals(q.getStatus())
                && (q.getExpireDate() == null || !q.getExpireDate().isBefore(LocalDate.now())));
        if ("PORK".equals(product.getBizType()) && !valid) {
            throw new BizException("鲜猪肉上架必须上传有效的检疫合格证明（两证两章）");
        }
        if ("PROCESSED".equals(product.getBizType())
                && quals.stream().noneMatch(q -> "SC".equals(q.getQualType()))) {
            throw new BizException("肉制品上架必须上传食品生产许可（SC）");
        }
    }

    @Transactional(rollbackFor = Exception.class)
    public void saveWithRelations(Product product, List<ProductSku> skus,
                                  List<ProductQualification> qualifications) {
        saveOrUpdate(product);
        if (skus != null) {
            skuService.remove(new LambdaQueryWrapper<ProductSku>().eq(ProductSku::getProductId, product.getId()));
            for (ProductSku sku : skus) {
                sku.setId(null);
                sku.setProductId(product.getId());
                skuService.save(sku);
            }
        }
        if (qualifications != null) {
            qualificationService.remove(new LambdaQueryWrapper<ProductQualification>()
                    .eq(ProductQualification::getProductId, product.getId()));
            for (ProductQualification qual : qualifications) {
                qual.setId(null);
                qual.setProductId(product.getId());
                qualificationService.save(qual);
            }
        }
    }

    public void audit(Long id, Integer status, String remark) {
        Product product = getById(id);
        if (product == null) {
            throw new BizException("商品不存在");
        }
        if (status != null && status == 1) {
            checkSellable(id);
        }
        Product update = new Product();
        update.setId(id);
        update.setStatus(status);
        update.setAuditRemark(remark);
        updateById(update);
    }

    public void changeStatus(Long id, Integer status) {
        if (status != null && status == 1) {
            checkSellable(id);
        }
        Product update = new Product();
        update.setId(id);
        update.setStatus(status);
        updateById(update);
    }
}
