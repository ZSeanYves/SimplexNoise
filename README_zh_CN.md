# 🎨 SimplexNoise：MoonBit 的 2D / 3D / 4D 程序噪声与 fBm 噪声库

[English](https://github.com/ZSeanYves/SimplexNoise/blob/main/README.md) | [简体中文](https://github.com/ZSeanYves/SimplexNoise/blob/main/README_zh_CN.md)

[![构建状态](https://img.shields.io/github/actions/workflow/status/ZSeanYves/SimplexNoise/simplex_noise_ci.yml)](https://github.com/ZSeanYves/SimplexNoise/actions)
[![许可证](https://img.shields.io/github/license/ZSeanYves/SimplexNoise)](LICENSE)

**SimplexNoise** 是一个轻量、模块化的 MoonBit 库，支持高性能的 2D / 3D / 4D Simplex 噪声和多八度的 fBm（分形布朗运动）噪声。功能包括域扰动（Domain Warping）、可平铺图像生成、灰度/彩色 PNG 渲染、切片输出等，适用于程序化地形、纹理、云图、模拟可视化与科研。

---

## 🚀 特性概览

* ✅ 基于种子与梯度的 2D / 3D / 4D Simplex 噪声生成
* ✅ 多八度 fBm 噪声（可调参数）
* ✅ 支持扰动效果（`strength~` 控制强度）
* ✅ 可平铺 Tileable 噪声与 fBm（`pi~` 控制周期）
* ✅ 支持灰度与彩色 PNG 输出
* ✅ 批量切片输出（3D / 4D）
* ✅ 与 Python 标准库兼容的梯度向量
* ✅ 完善测试用例，涵盖取值范围、平滑性、Python 对比等

---

## 📦 安装方式

```bash
moon add ZSeanYves/SimplexNoise
```

或手动在 `moon.mod.json` 中添加：

```json
"import": ["ZSeanYves/SimplexNoise"]
```

---

## 🧪 使用示例

### 2D 彩色 fBm + 扰动

```moonbit
let config = @ZSeanYves/SimplexNoise.new_NoiseConfig(6, 0.5, 2.0, 0.03)
let (_, grads) = @ZSeanYves/SimplexNoise.create2d(42)
@ZSeanYves/SimplexNoise.fbm2d_image("./fbm2d.png", 256, 256, 42, grads, config, true, false, strength~ = 2.5)
```

### 3D 可平铺 fBm（灰度）

```moonbit
let config = new_NoiseConfig(5, 0.5, 2.0, 0.03)
let (_, grads) = create3d(99)
@ZSeanYves/SimplexNoise.tfbm3d_image("./tile3d.png", 256, 256, 64, 99, 0.0, grads, config, pi~ = 3.14, true)
```

### 4D 切片输出

```moonbit
let config = new_NoiseConfig(4, 0.5, 2.0, 0.03)
let (_, grads) = create4d(123)
@ZSeanYves/SimplexNoise.fbm4d_slices("./slices", 128, 128, 64, 123, grads, config, false, true, 10)
```

---

## 📘 核心接口概览

| 函数名              | 维度 | 类型  | 可平铺 | 扰动 | 切片 | 输出  |
| ---------------- | -- | --- | --- | -- | -- | --- |
| `noise2d_image`  | 2D | 基础  | ❌   | ✅  | ❌  | PNG |
| `fbm2d_image`    | 2D | fBm | ❌   | ✅  | ❌  | PNG |
| `tnoise2d_image` | 2D | 基础  | ✅   | ❌  | ❌  | PNG |
| `tfbm2d_image`   | 2D | fBm | ✅   | ❌  | ❌  | PNG |
| `noise3d_image`  | 3D | 基础  | ❌   | ✅  | ❌  | PNG |
| `fbm3d_image`    | 3D | fBm | ❌   | ✅  | ❌  | PNG |
| `tnoise3d_image` | 3D | 基础  | ✅   | ❌  | ❌  | PNG |
| `tfbm3d_image`   | 3D | fBm | ✅   | ❌  | ❌  | PNG |
| `noise3d_slices` | 3D | 基础  | ❌   | ✅  | ✅  | PNG |
| `fbm3d_slices`   | 3D | fBm | ❌   | ✅  | ✅  | PNG |
| `noise4d_image`  | 4D | 基础  | ❌   | ✅  | ❌  | PNG |
| `fbm4d_image`    | 4D | fBm | ❌   | ✅  | ❌  | PNG |
| `tnoise4d_image` | 4D | 基础  | ✅   | ❌  | ❌  | PNG |
| `tfbm4d_image`   | 4D | fBm | ✅   | ❌  | ❌  | PNG |
| `noise4d_slices` | 4D | 基础  | ❌   | ✅  | ✅  | PNG |
| `fbm4d_slices`   | 4D | fBm | ❌   | ✅  | ✅  | PNG |

---

## 🎛️ 参数说明

| 参数名             | 含义描述                          |
| --------------- | ----------------------------- |
| `width, height` | 图像尺寸（像素）                      |
| `depth, time`   | 平铺 3D / 4D 输出所需维度             |
| `scale`         | 控制频率（越小越平滑）                   |
| `seed`          | 种子值（用于生成置换表）                  |
| `grads`         | 梯度向量（预定义 / 自定义）               |
| `z, w`          | 3D / 4D 切片位置                  |
| `pi~`           | 周期性参数，控制平铺边界（默认 3.14）         |
| `strength~`     | 扰动强度，开启 `useWarp` 后生效（默认 1.0） |
| `isGrayScale`   | 是否输出灰度图（否则为 RGB 彩色）           |

---

## 📂 项目结构

```
SimplexNoise/
├── src/
│   ├── noise2d.mbt / noise3d.mbt / noise4d.mbt     # Simplex 核心逻辑
│   ├── fbm.mbt / fbm3d.mbt / fbm4d.mbt             # fBm 递归模块
│   ├── image_gen.mbt / slice.mbt                   # 图像渲染与批量切片
│   ├── simplex_noise.mbt / SimplexNoise.mbti       # 接口导出
│   ├── hash.mbt                                    # 构建哈希表
│   └── simplex_noise_test.mbt                      # 测试用例模块
├── examples/                                       # 输出样图
├── moon.pkg.json / LICENSE / README.md
```

---

## ✅ 测试说明

执行测试命令：

```bash
moon test -p ZSeanYves/SimplexNoise
```

### ☑️ 覆盖内容

* 📷 图像输出测试（Basic / fBm / Warp / Tileable / Color / Gray）
* 📈 数值正确性（值域范围、平滑性、梯度归一）
* 🔁 Python 标准库对比（snoise2/3/4, fbm）
* 🧪 批量切片（3D / 4D）

测试图像统一输出至 `src/examples/` 子目录中，便于可视化检查与对比验证。

---

## 📌 未来计划

* 🎨 输出法线图 / 高光图（解析导数）

---

## 📜 开源协议

本项目采用 MIT License 许可，详见 [LICENSE](./LICENSE)。
