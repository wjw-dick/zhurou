package com.zhushi.common.core;

import java.util.List;

/**
 * 树节点接口
 */
public interface TreeNode<T> {

    Long getId();

    Long getParentId();

    Integer getSort();

    List<T> getChildren();

    void setChildren(List<T> children);
}
