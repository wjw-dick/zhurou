package com.zhushi.common.util;

import com.zhushi.common.core.TreeNode;

import java.util.ArrayList;
import java.util.Comparator;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

/**
 * 树结构构建工具
 */
public class TreeUtil {

    public static <T extends TreeNode<T>> List<T> build(List<T> list) {
        if (list == null || list.isEmpty()) {
            return new ArrayList<>();
        }
        Map<Long, T> map = new LinkedHashMap<>();
        for (T node : list) {
            if (node.getChildren() == null) {
                node.setChildren(new ArrayList<>());
            }
            map.put(node.getId(), node);
        }
        List<T> roots = new ArrayList<>();
        for (T node : list) {
            Long pid = node.getParentId();
            if (pid == null || pid == 0L || !map.containsKey(pid)) {
                roots.add(node);
            } else {
                map.get(pid).getChildren().add(node);
            }
        }
        sort(roots);
        return roots;
    }

    private static <T extends TreeNode<T>> void sort(List<T> nodes) {
        if (nodes == null || nodes.isEmpty()) {
            return;
        }
        nodes.sort(Comparator.comparing(n -> n.getSort() == null ? 0 : n.getSort()));
        for (T node : nodes) {
            sort(node.getChildren());
        }
    }
}
