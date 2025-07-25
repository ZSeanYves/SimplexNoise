// 统一配置结构
pub struct NoiseConfig {
  octaves : Int
  persistence : Float
  lacunarity : Float
  scale : Float
}


// 预定义 8 个 2D 单位向量作为梯度集合
pub let grads2d : Array[Array[Float]] = [
  [1.0, 0.0],
  [-1.0, 0.0],
  [0.0, 1.0],
  [0.0, -1.0],
  [0.70710678, 0.70710678],
  [-0.70710678, 0.70710678],
  [0.70710678, -0.70710678],
  [-0.70710678, -0.70710678],
]

// 预定义 12 个 3D 单位向量作为梯度集合
pub let grads3d : Array[Array[Float]] = [
  [1.0, 1.0, 0.0],
  [-1.0, 1.0, 0.0],
  [1.0, -1.0, 0.0],
  [-1.0, -1.0, 0.0],
  [1.0, 0.0, 1.0],
  [-1.0, 0.0, 1.0],
  [1.0, 0.0, -1.0],
  [-1.0, 0.0, -1.0],
  [0.0, 1.0, 1.0],
  [0.0, -1.0, 1.0],
  [0.0, 1.0, -1.0],
  [0.0, -1.0, -1.0],
]

// 预定义 32 个 4D 单位向量作为梯度集合
pub let grads4d : Array[Array[Float]] = [
  [0.0, 1.0, 1.0, 1.0],
  [0.0, 1.0, 1.0, -1.0],
  [0.0, 1.0, -1.0, 1.0],
  [0.0, 1.0, -1.0, -1.0],
  [0.0, -1.0, 1.0, 1.0],
  [0.0, -1.0, 1.0, -1.0],
  [0.0, -1.0, -1.0, 1.0],
  [0.0, -1.0, -1.0, -1.0],
  [1.0, 0.0, 1.0, 1.0],
  [1.0, 0.0, 1.0, -1.0],
  [1.0, 0.0, -1.0, 1.0],
  [1.0, 0.0, -1.0, -1.0],
  [-1.0, 0.0, 1.0, 1.0],
  [-1.0, 0.0, 1.0, -1.0],
  [-1.0, 0.0, -1.0, 1.0],
  [-1.0, 0.0, -1.0, -1.0],
  [1.0, 1.0, 0.0, 1.0],
  [1.0, 1.0, 0.0, -1.0],
  [1.0, -1.0, 0.0, 1.0],
  [1.0, -1.0, 0.0, -1.0],
  [-1.0, 1.0, 0.0, 1.0],
  [-1.0, 1.0, 0.0, -1.0],
  [-1.0, -1.0, 0.0, 1.0],
  [-1.0, -1.0, 0.0, -1.0],
  [1.0, 1.0, 1.0, 0.0],
  [1.0, 1.0, -1.0, 0.0],
  [1.0, -1.0, 1.0, 0.0],
  [1.0, -1.0, -1.0, 0.0],
  [-1.0, 1.0, 1.0, 0.0],
  [-1.0, 1.0, -1.0, 0.0],
  [-1.0, -1.0, 1.0, 0.0],
  [-1.0, -1.0, -1.0, 0.0],
]



pub fn new_NoiseConfig(
  octaves : Int,
  persistence : Float,
  lacunarity : Float,
  scale : Float
) -> NoiseConfig {
  let config : NoiseConfig = { octaves, persistence, lacunarity, scale }
  config
}



// 2D Simplex 噪声核心算法
// 初始化置换表和梯度表,允许自定义种子
pub fn create2d(seed : Int) -> (Array[Int], Array[Array[Float]]) {
  let perm_table = init_noise(seed)
  (perm_table, grads2d)
}

// 生成单点 2D Simplex 噪声
pub fn noise2d(
  p : Array[Float],
  perm_table : Array[Int],
  grads : Array[Array[Float]],
  scale : Float
) -> Float {
  simplex2d(p, perm_table, grads, scale)
}
// 八度数 fBm 噪声
// pub fn fbm2d(p: Array[Float], octaves: Int, persistence: Float, lacunarity: Float, perm_table: Array[Int], grads: Array[Array[Float]]) -> Float 

// 调试辅助：输出单个顶点贡献过程
//pub fn simplex2d_debug(p: Array[Float], perm_table: Array[Int], grads: Array[Array[Float]]) -> Array[Float] 


pub fn noise2d_image(
  path : String,
  width : Int,
  height : Int,
  scale : Float,
  seed : Int,
  grads : Array[Array[Float]],
  useWarp : Bool,
  isGrayScale : Bool,
  strength~ : Float = 1.0
) -> Bool raise Error {
  let png_data = generate_noise_png_buffer(
    width, height, scale, seed, grads, useWarp, isGrayScale, strength,
  )
  save_png(path, png_data)
}


pub fn fbm2d_image(
  path : String,
  width : Int,
  height : Int,
  seed : Int,
  grads : Array[Array[Float]],
  config : NoiseConfig,
  useWarp : Bool,
  isGrayScale : Bool,
  strength~ : Float = 1.0
) -> Bool raise Error {
  let png_data = generate_fbm_png_buffer(
    width,
    height,
    config.scale,
    seed,
    config.octaves,
    config.persistence,
    config.lacunarity,
    grads,
    useWarp,
    isGrayScale,
    strength,
  )
  save_png(path, png_data)
}

pub fn tnoise2d_image(
  path : String,
  width : Int,
  height : Int,
  scale : Float,
  seed : Int,
  grads : Array[Array[Float]],
  pi~ : Double = 3.14159265358979323846,
  isGrayScale : Bool
) -> Bool raise Error {
  let png_data = generate_tileable_noise2d_image(
    width, height, scale, seed, grads, pi, isGrayScale,
  )
  save_png(path, png_data)
}

pub fn tfbm2d_image(
  path : String,
  width : Int,
  height : Int,
  seed : Int,
  grads : Array[Array[Float]],
  config : NoiseConfig,
  pi~ : Double = 3.14159265358979323846,
  isGrayScale : Bool
) -> Bool raise Error {
  let png_data = generate_tileable_fbm2d_image(
    width, height, config, seed, grads, pi, isGrayScale,
  )
  save_png(path, png_data)
}


// 3D Simplex 噪声核心算法
// 生成单点 3D Simplex 噪声

pub fn create3d(seed : Int) -> (Array[Int], Array[Array[Float]]) {
  let perm_table = init_noise(seed)
  (perm_table, grads3d)
}

pub fn noise3d(
  p : Array[Float],
  perm_table : Array[Int],
  grads : Array[Array[Float]],
  scale : Float
) -> Float {
  simplex3d(p, perm_table, grads, scale)
}

// 八度数 fBm 噪声
//pub fn fbm3d(p : Array[Float],octaves : Int,persistence : Float,lacunarity : Float,perm_table : Array[Int],grads : Array[Array[Float]]) -> Float

pub fn noise3d_image(
  path : String,
  width : Int,
  height : Int,
  scale : Float,
  z : Float,
  seed : Int,
  grads : Array[Array[Float]],
  useWarp : Bool,
  isGrayScale : Bool,
  strength~ : Float = 1.0
) -> Bool raise Error {
  let png_data = generate_noise3d_png_buffer(
    width, height, scale, z, seed, grads, useWarp, isGrayScale, strength,
  )
  save_png(path, png_data)
}

pub fn fbm3d_image(
  path : String,
  width : Int,
  height : Int,
  z : Float,
  seed : Int,
  grads : Array[Array[Float]],
  config : NoiseConfig,
  useWarp : Bool,
  isGrayScale : Bool,
  strength~ : Float = 1.0
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
    grads,
    useWarp,
    isGrayScale,
    strength,
  )
  save_png(path, png_data)
}

pub fn tnoise3d_image(
  path : String,
  width : Int,
  height : Int,
  depth : Int,
  scale : Float,
  seed : Int,
  z : Float,
  grads : Array[Array[Float]],
  pi~ : Double = 3.14159265358979323846,
  isGrayScale : Bool
) -> Bool raise Error {
  let png_data = generate_tileable_noise3d_image(
    width, height, depth, z, scale, seed, grads, pi, isGrayScale,
  )
  save_png(path, png_data)
}

pub fn tfbm3d_image(
  path : String,
  width : Int,
  height : Int,
  depth : Int,
  seed : Int,
  z : Float,
  grads : Array[Array[Float]],
  config : NoiseConfig,
  pi~ : Double = 3.14159265358979323846,
  isGrayScale : Bool
) -> Bool raise Error {
  let png_data = generate_tileable_fbm3d_image(
    width, height, depth, z, config, seed, grads, pi, isGrayScale,
  )
  save_png(path, png_data)
}


// 4D Simplex 噪声核心算法
// 生成单点 4D Simplex 噪声
pub fn create4d(seed : Int) -> (Array[Int], Array[Array[Float]]) {
  let perm_table = init_noise(seed)
  (perm_table, grads4d)
}

pub fn noise4d(
  p : Array[Float],
  perm_table : Array[Int],
  grads : Array[Array[Float]],
  scale : Float
) -> Float {
  simplex4d(p, perm_table, grads, scale)
}


// 八度数 fBm 噪声
// pub fn fbm4d(p : Array[Float], octaves : Int, persistence : Float, lacunarity : Float, perm_table : Array[Int], grads : Array[Array[Float]]) -> Float

pub fn noise4d_image(
  path : String,
  width : Int,
  height : Int,
  scale : Float,
  z : Float,
  w : Float,
  seed : Int,
  grads : Array[Array[Float]],
  useWarp : Bool,
  isGrayScale : Bool,
  strength~ : Float = 1.0
) -> Bool raise Error {
  let png_data = generate_noise4d_png_buffer(
    width, height, scale, z, w, seed, grads, useWarp, isGrayScale, strength,
  )
  save_png(path, png_data)
}



pub fn fbm4d_image(
  path : String,
  width : Int,
  height : Int,
  z : Float,
  w : Float,
  seed : Int,
  grads : Array[Array[Float]],
  config : NoiseConfig,
  useWarp : Bool,
  isGrayScale : Bool,
  strength~ : Float = 1.0
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
    grads,
    useWarp,
    isGrayScale,
    strength,
  )
  save_png(path, png_data)
}

pub fn tnoise4d_image(
  path : String,
  width : Int,
  height : Int,
  depth : Int,
  time : Int,
  z : Float,
  w : Float,
  seed : Int,
  grads : Array[Array[Float]],
  scale : Float,
  pi~ : Double = 3.14159265358979323846,
  isGrayScale : Bool
) -> Bool raise Error {
  let png_data = generate_tileable_noise4d_image(
    width, height, depth, time, z, w, seed, scale, grads, pi, isGrayScale,
  )
  save_png(path, png_data)
}

pub fn tfbm4d_image(
  path : String,
  width : Int,
  height : Int,
  depth : Int,
  time : Int,
  z : Float,
  w : Float,
  seed : Int,
  grads : Array[Array[Float]],
  config : NoiseConfig,
  pi~ : Double = 3.14159265358979323846,
  isGrayScale : Bool
) -> Bool raise Error {
  let png_data = generate_tileable_fbm4d_image(
    width, height, depth, time, z, w, seed, config, grads, pi, isGrayScale,
  )
  save_png(path, png_data)
}
