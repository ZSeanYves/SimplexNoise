// 统一配置结构
pub struct NoiseConfig {
  octaves: Int
  persistence: Float
  lacunarity: Float
  scale: Float
}

// 预定义 8 个 2D 单位向量作为梯度集合
pub let grads: Array[Array[Float]] = [
  [1.0, 0.0],
  [-1.0, 0.0],
  [0.0, 1.0],
  [0.0, -1.0],
  [0.70710678, 0.70710678],
  [-0.70710678, 0.70710678],
  [0.70710678, -0.70710678],
  [-0.70710678, -0.70710678]
]

// 预定义 12 个 3D 单位向量作为梯度集合
pub let grads3d: Array[Array[Float]] = [
  [1.0, 1.0, 0.0], [-1.0, 1.0, 0.0], [1.0, -1.0, 0.0], [-1.0, -1.0, 0.0],
  [1.0, 0.0, 1.0], [-1.0, 0.0, 1.0], [1.0, 0.0, -1.0], [-1.0, 0.0, -1.0],
  [0.0, 1.0, 1.0], [0.0, -1.0, 1.0], [0.0, 1.0, -1.0], [0.0, -1.0, -1.0]
]

// 预定义 32 个 4D 单位向量作为梯度集合
pub let grads4d: Array[Array[Float]] = [
  [ 0.0,  1.0,  1.0,  1.0], [ 0.0,  1.0,  1.0, -1.0],
  [ 0.0,  1.0, -1.0,  1.0], [ 0.0,  1.0, -1.0, -1.0],
  [ 0.0, -1.0,  1.0,  1.0], [ 0.0, -1.0,  1.0, -1.0],
  [ 0.0, -1.0, -1.0,  1.0], [ 0.0, -1.0, -1.0, -1.0],
  [ 1.0,  0.0,  1.0,  1.0], [ 1.0,  0.0,  1.0, -1.0],
  [ 1.0,  0.0, -1.0,  1.0], [ 1.0,  0.0, -1.0, -1.0],
  [-1.0,  0.0,  1.0,  1.0], [-1.0,  0.0,  1.0, -1.0],
  [-1.0,  0.0, -1.0,  1.0], [-1.0,  0.0, -1.0, -1.0],
  [ 1.0,  1.0,  0.0,  1.0], [ 1.0,  1.0,  0.0, -1.0],
  [ 1.0, -1.0,  0.0,  1.0], [ 1.0, -1.0,  0.0, -1.0],
  [-1.0,  1.0,  0.0,  1.0], [-1.0,  1.0,  0.0, -1.0],
  [-1.0, -1.0,  0.0,  1.0], [-1.0, -1.0,  0.0, -1.0],
  [ 1.0,  1.0,  1.0,  0.0], [ 1.0,  1.0, -1.0,  0.0],
  [ 1.0, -1.0,  1.0,  0.0], [ 1.0, -1.0, -1.0,  0.0],
  [-1.0,  1.0,  1.0,  0.0], [-1.0,  1.0, -1.0,  0.0],
  [-1.0, -1.0,  1.0,  0.0], [-1.0, -1.0, -1.0,  0.0]
]



pub fn new_NoiseConfig(octaves: Int, persistence: Float, lacunarity: Float, scale: Float) -> NoiseConfig {
  let config:NoiseConfig = {octaves, persistence, lacunarity, scale}
  config
}



// 2D Simplex 噪声核心算法
// 初始化置换表和梯度表,允许自定义种子
pub fn create_simplex_noise(seed: Int) -> (Array[Int], Array[Array[Float]]) {
  let perm_table = init_noise(seed)
  (perm_table, grads)
}

// 生成单点 2D Simplex 噪声
pub fn noise2d(p: Array[Float], perm_table: Array[Int], grads: Array[Array[Float]]) -> Float {
  simplex2d(p, perm_table, grads)
}
// 八度数 fBm 噪声
// pub fn fbm2d(p: Array[Float], octaves: Int, persistence: Float, lacunarity: Float, perm_table: Array[Int], grads: Array[Array[Float]]) -> Float 

// 调试辅助：输出单个顶点贡献过程
//pub fn simplex2d_debug(p: Array[Float], perm_table: Array[Int], grads: Array[Array[Float]]) -> Array[Float] 


// 生成并保存 Simplex 噪声 PNG 图像
pub fn generate_and_save_noise_image(
  path : String,
  width : Int,
  height : Int,
  scale : Float,
  seed : Int,
  grads : Array[Array[Float]]
) -> Bool raise Error {
  let png_data = generate_noise_png_buffer(width, height, scale, seed, grads)
  save_png(path, png_data)
}

// 生成并保存 fBm 噪声 PNG 图像，允许自定义八度配置
pub fn generate_and_save_fbm_image(
  path : String,
  width : Int,
  height : Int,
  seed : Int,
  grads : Array[Array[Float]],
  config : NoiseConfig
) -> Bool raise Error {
  let png_data = generate_fbm_png_buffer(
    width,   height,
    config.scale,
    seed,
    config.octaves,
    config.persistence,
    config.lacunarity,
    grads,
  )
  save_png(path, png_data)
}

// 生成并保存彩色 Simplex 噪声 PNG 图像
pub fn generate_and_save_noise_image_color(
  path : String,
  width : Int,
  height : Int,
  scale : Float,
  seed : Int,
  grads : Array[Array[Float]]
) -> Bool raise Error {
  let png_data = generate_noise_png_buffer_color(width, height, scale, seed, grads)
  save_png(path, png_data)
}

// 生成并保存彩色 fBm 噪声 PNG 图像，允许自定义八度配置
pub fn generate_and_save_fbm_image_color(
  path : String,
  width : Int,
  height : Int,
  seed : Int,
  grads : Array[Array[Float]],
  config : NoiseConfig
) -> Bool raise Error {
  let png_data = generate_fbm_png_buffer_color(
    width,
    height,
    config.scale,
    seed,
    config.octaves,
    config.persistence,
    config.lacunarity,
    grads
  )
  save_png(path, png_data)
}


// 3D Simplex 噪声核心算法
// 生成单点 3D Simplex 噪声

pub fn create_simplex_noise3d(seed: Int) -> (Array[Int], Array[Array[Float]]) {
  let perm_table = init_noise(seed)
  (perm_table, grads3d)
}

pub fn noise3d(
  p : Array[Float],
  perm_table : Array[Int],
  grads : Array[Array[Float]]
) -> Float {
  simplex3d(p, perm_table, grads)
}

// 八度数 fBm 噪声
//pub fn fbm3d(p : Array[Float],octaves : Int,persistence : Float,lacunarity : Float,perm_table : Array[Int],grads : Array[Array[Float]]) -> Float

// 生成并保存 3D Simplex 噪声切片图像 (灰度)
pub fn generate_and_save_noise3d_image(
  path : String,
  width : Int,
  height : Int,
  scale : Float,
  z : Float,
  seed : Int,
  grads : Array[Array[Float]]
) -> Bool raise Error {
  let png_data = generate_noise3d_png_buffer(width, height, scale, z, seed, grads)
  save_png(path, png_data)
}
// 生成并保存 3D fBm 噪声切片图像 (灰度)
pub fn generate_and_save_fbm3d_image(
  path : String,
  width : Int,
  height : Int,
  z : Float,
  seed : Int,
  grads : Array[Array[Float]],
  config : NoiseConfig
) -> Bool raise Error {
  let png_data = generate_fbm3d_png_buffer(
    width,
    height,
    config.scale,
    z,
    seed,
    config.octaves,
    config.persistence,
    config.lacunarity,
    grads
  )
  save_png(path, png_data)
}

// 生成并保存 3D Simplex 噪声切片图像 (彩色)
pub fn generate_and_save_noise3d_image_color(
  path : String,
  width : Int,
  height : Int,
  scale : Float,
  z : Float,
  seed : Int,
  grads : Array[Array[Float]]
) -> Bool raise Error {
  let png_data = generate_noise3d_png_buffer_color(width, height, scale, z, seed, grads)
  save_png(path, png_data)
}

// 生成并保存 3D fBm 噪声切片图像 (彩色)
pub fn generate_and_save_fbm3d_image_color(
  path : String,
  width : Int,
  height : Int,
  z : Float,
  seed : Int,
  grads : Array[Array[Float]],
  config : NoiseConfig
) -> Bool raise Error {
  let png_data = generate_fbm3d_png_buffer_color(
    width,
    height,
    config.scale,
    z,
    seed,
    config.octaves,
    config.persistence,
    config.lacunarity,
    grads
  )
  save_png(path, png_data)
}

// 4D Simplex 噪声核心算法
// 生成单点 4D Simplex 噪声
pub fn create_simplex_noise4d(seed : Int) -> (Array[Int], Array[Array[Float]]) {
  let perm_table = init_noise(seed)
  (perm_table, grads4d)
}

pub fn noise4d(
  p : Array[Float],
  perm_table : Array[Int],
  grads : Array[Array[Float]]
) -> Float {
  simplex4d(p, perm_table, grads)
}


// 八度数 fBm 噪声
// pub fn fbm4d(p : Array[Float], octaves : Int, persistence : Float, lacunarity : Float, perm_table : Array[Int], grads : Array[Array[Float]]) -> Float

// 生成并保存 4D Simplex 噪声切片图像 (灰度)
pub fn generate_and_save_noise4d_image(
  path : String,
  width : Int,
  height : Int,
  scale : Float,
  z : Float,
  w : Float,
  seed : Int,
  grads : Array[Array[Float]]
) -> Bool raise Error {
  let png_data = generate_noise4d_png_buffer(width, height, scale, z, w, seed, grads)
  save_png(path, png_data)
}


// 生成并保存 4D fBm 噪声切片图像 (灰度)
pub fn generate_and_save_fbm4d_image(
  path : String,
  width : Int,
  height : Int,
  z : Float,
  w : Float,
  seed : Int,
  grads : Array[Array[Float]],
  config : NoiseConfig
) -> Bool raise Error {
  let png_data = generate_fbm4d_png_buffer(
    width,
    height,
    config.scale,
    z,
    w,
    seed,
    config.octaves,
    config.persistence,
    config.lacunarity,
    grads
  )
  save_png(path, png_data)
}


// 生成并保存 4D Simplex 噪声切片图像 (彩色)
pub fn generate_and_save_noise4d_image_color(
  path : String,
  width : Int,
  height : Int,
  scale : Float,
  z : Float,
  w : Float,
  seed : Int,
  grads : Array[Array[Float]]
) -> Bool raise Error {
  let png_data = generate_noise4d_png_buffer_color(width, height, scale, z, w, seed, grads)
  save_png(path, png_data)
}


// 生成并保存 4D fBm 噪声切片图像 (彩色)
pub fn generate_and_save_fbm4d_image_color(
  path : String,
  width : Int,
  height : Int,
  z : Float,
  w : Float,
  seed : Int,
  grads : Array[Array[Float]],
  config : NoiseConfig
) -> Bool raise Error {
  let png_data = generate_fbm4d_png_buffer_color(
    width,
    height,
    config.scale,
    z,
    w,
    seed,
    config.octaves,
    config.persistence,
    config.lacunarity,
    grads
  )
  save_png(path, png_data)
}
