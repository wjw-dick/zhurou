package com.zhushi.oss.service;

import cn.hutool.core.date.DateUtil;
import cn.hutool.core.util.IdUtil;
import cn.hutool.core.util.StrUtil;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.zhushi.common.exception.BizException;
import com.zhushi.oss.entity.OssFile;
import com.zhushi.oss.mapper.OssFileMapper;
import com.zhushi.oss.storage.OssStorage;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.util.Date;
import java.util.Set;

/**
 * 文件上传服务（走当前生效的对象存储驱动）
 */
@Service
@RequiredArgsConstructor
public class OssFileService extends ServiceImpl<OssFileMapper, OssFile> {

    private static final Set<String> IMAGE_EXT = Set.of("jpg", "jpeg", "png", "gif", "webp", "bmp");
    private static final Set<String> DOC_EXT = Set.of("pdf", "doc", "docx", "xls", "xlsx", "ppt", "pptx", "txt");
    private static final Set<String> MEDIA_EXT = Set.of("mp4", "mp3", "wav", "mov");

    private final OssConfigService ossConfigService;

    public OssFile upload(MultipartFile file, String bizType) {
        if (file == null || file.isEmpty()) {
            throw new BizException("请选择要上传的文件");
        }
        String original = file.getOriginalFilename() == null ? "file" : file.getOriginalFilename();
        String ext = StrUtil.subAfter(original, ".", true).toLowerCase();
        String dir = resolveDir(ext);
        String path = dir + "/" + DateUtil.format(new Date(), "yyyyMMdd")
                + "/" + IdUtil.fastSimpleUUID() + (ext.isEmpty() ? "" : "." + ext);

        OssStorage storage = ossConfigService.storage();
        byte[] bytes;
        try {
            bytes = file.getBytes();
        } catch (IOException e) {
            throw new BizException("读取上传文件失败");
        }
        String url = storage.upload(bytes, path, file.getContentType());

        OssFile record = new OssFile();
        record.setFileName(original);
        record.setFilePath(path);
        record.setUrl(url);
        record.setFileSize(file.getSize());
        record.setContentType(file.getContentType());
        record.setDriver(storage.driver());
        record.setBizType(bizType);
        save(record);
        return record;
    }

    public void deleteByPath(String path) {
        OssStorage storage = ossConfigService.storage();
        storage.delete(path);
        remove(new com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper<OssFile>()
                .eq(OssFile::getFilePath, path));
    }

    private String resolveDir(String ext) {
        if (IMAGE_EXT.contains(ext)) {
            return "image";
        }
        if (DOC_EXT.contains(ext)) {
            return "document";
        }
        if (MEDIA_EXT.contains(ext)) {
            return "media";
        }
        return "other";
    }
}
