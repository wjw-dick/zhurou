# tabBar 图标说明

当前 `app.json` 的 `tabBar` **只配置了 `text` 文字**，未配置 `iconPath` / `selectedIconPath`。

## 为什么不配图标？

微信小程序在 `tabBar` 中一旦填写了 `iconPath`，编译时就会去读取对应图片文件；
如果文件不存在会直接**编译报错**。为避免脚手架空目录导致构建失败，这里改为纯文字 tabBar
（微信允许 tabBar 不设置图标，仅显示文字）。

## 需要图标时怎么做

1. 在本目录放入 5 组图标（普通态 + 选中态，建议 81×81px PNG，单张不超过 40KB）：

   | 文件名 | 用途 |
   |---|---|
   | `home.png` / `home-active.png` | 首页 |
   | `category.png` / `category-active.png` | 分类 |
   | `reserve.png` / `reserve-active.png` | 鲜肉预订 |
   | `cart.png` / `cart-active.png` | 购物车 |
   | `mine.png` / `mine-active.png` | 我的 |

2. 然后在 `app.json` 的 `tabBar.list` 中为每一项补上：

   ```json
   {
     "pagePath": "pages/index/index",
     "text": "首页",
     "iconPath": "assets/tabbar/home.png",
     "selectedIconPath": "assets/tabbar/home-active.png"
   }
   ```

> 图标建议：主色 `#c8161d` 中国红作为选中态，未选中态使用 `#7a7a7a` 灰色。
