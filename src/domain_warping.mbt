/// 使用一个噪声函数扭曲另一个噪声函数的输入坐标（质数偏移）
fn warp2d(
  grads : Array[Array[Float]],
  p : Array[Float],
  seed : Int,
  scale : Float, // 扰动噪声频率
  strength : Float // 扰动强度
) -> Float {
  // 初始化噪声的排列
  let perm = init_noise(seed)

  // 使用两个独立的扭曲向量
  // 使用质数偏移来避免 warp_x 和 warp_y 之间的干扰
  let warp_x = simplex2d([p[0], p[1]], perm, grads, scale)
  let warp_y = simplex2d(
    [
      p[0] + 19.19, // 质数偏移1
      p[1] + 29.29, // 质数偏移2
    ], 
    perm,
    grads,
    scale,
  )
  let warped = [

    // 计算扭曲后的坐标
    p[0] + warp_x * strength,
    p[1] + warp_y * strength,
  ]

  // 返回最终的噪声值
  simplex2d(warped, perm, grads, 1)
}


fn warp_fbm2d(
  grads : Array[Array[Float]],
  p : Array[Float],
  seed : Int,
  scale : Float,
  strength : Float,
  octaves : Int,
  persistence : Float,
  lacunarity : Float
) -> Float {
  let perm = init_noise(seed)
  let warp_x = fbm2d(
    [p[0], p[1]],
    octaves,
    persistence,
    lacunarity,
    perm,
    grads,
    scale,
  )
  let warp_y = fbm2d(
    [p[0] + 19.19, p[1] + 29.29],
    octaves,
    persistence,
    lacunarity,
    perm,
    grads,
    scale,
  )
  let warped = [p[0] + warp_x * strength, p[1] + warp_y * strength]
  fbm2d(warped, octaves, persistence, lacunarity, perm, grads, 1)
}
//
//
//
//
//
//
//
//
//3D
fn warp3d(
  grads: Array[Array[Float]], 
  p: Array[Float], 
  seed: Int, 
  scale: Float, 
  strength: Float
) -> Float {
  let perm = init_noise(seed)

  let warp_x = simplex3d(
    [p[0], p[1], p[2]],
    perm,
    grads,
    scale
  )
  let warp_y = simplex3d(
    [p[0] + 19.19, p[1] + 29.29, p[2] + 37.37],
    perm,
    grads,
    scale
  )
  let warp_z = simplex3d(
    [p[0] + 41.41, p[1] + 53.53, p[2] + 67.67],
    perm,
    grads,
    scale
  )

  let warped = [
    p[0] + warp_x * strength,
    p[1] + warp_y * strength,
    p[2] + warp_z * strength,
  ]

  simplex3d(warped, perm, grads, 1)
}


fn warp_fbm3d(
  grads: Array[Array[Float]], 
  p: Array[Float], 
  seed: Int, 
  scale: Float, 
  strength: Float, 
  octaves: Int, 
  persistence: Float, 
  lacunarity: Float
) -> Float {
  let perm = init_noise(seed)

  let warp_x = fbm3d(
    [p[0], p[1], p[2]],
    octaves,
    persistence,
    lacunarity,
    perm,
    grads,
    scale
  )
  let warp_y = fbm3d(
    [p[0] + 19.19, p[1] + 29.29, p[2] + 37.37],
    octaves,
    persistence,
    lacunarity,
    perm,
    grads,
    scale
  )
  let warp_z = fbm3d(
    [p[0] + 41.41, p[1] + 53.53, p[2] + 67.67],
    octaves,
    persistence,
    lacunarity,
    perm,
    grads,
    scale
  )

  let warped = [
    p[0] + warp_x * strength,
    p[1] + warp_y * strength,
    p[2] + warp_z * strength,
  ]

  fbm3d(warped, octaves, persistence, lacunarity, perm, grads, scale)
}
//
//
//
//
//
//
//
//
//4D
fn warp4d(
  grads : Array[Array[Float]],
  p : Array[Float],
  seed : Int,
  scale : Float,
  strength : Float
) -> Float {
  let perm = init_noise(seed)
  let warp_x = simplex4d([p[0], p[1], p[2], p[3]], perm, grads, scale)
  let warp_y = simplex4d(
    [p[0] + 19.19, p[1] + 29.29, p[2] + 41.41, p[3] + 53.53],
    perm,
    grads,
    scale,
  )
  let warp_z = simplex4d(
    [p[0] + 67.67, p[1] + 79.79, p[2] + 91.91, p[3] + 103.103],
    perm,
    grads,
    scale,
  )
  let warp_w = simplex4d(
    [p[0] + 113.113, p[1] + 127.127, p[2] + 137.137, p[3] + 149.149],
    perm,
    grads,
    scale,
  )
  let warped = [
    p[0] + warp_x * strength,
    p[1] + warp_y * strength,
    p[2] + warp_z * strength,
    p[3] + warp_w * strength,
  ]
  simplex4d(warped, perm, grads, 1)
}

fn warp_fbm4d(
  grads : Array[Array[Float]],
  p : Array[Float],
  seed : Int,
  scale : Float,
  strength : Float,
  octaves : Int,
  persistence : Float,
  lacunarity : Float
) -> Float {
  let perm = init_noise(seed)
  let warp_x = fbm4d(
    [p[0], p[1], p[2], p[3]],
    octaves,
    persistence,
    lacunarity,
    perm,
    grads,
    scale,
  )
  let warp_y = fbm4d(
    [p[0] + 19.19, p[1] + 29.29, p[2] + 41.41, p[3] + 53.53],
    octaves,
    persistence,
    lacunarity,
    perm,
    grads,
    scale,
  )
  let warp_z = fbm4d(
    [p[0] + 67.67, p[1] + 79.79, p[2] + 91.91, p[3] + 103.103],
    octaves,
    persistence,
    lacunarity,
    perm,
    grads,
    scale,
  )
  let warp_w = fbm4d(
    [p[0] + 113.113, p[1] + 127.127, p[2] + 137.137, p[3] + 149.149],
    octaves,
    persistence,
    lacunarity,
    perm,
    grads,
    scale,
  )
  let warped = [
    p[0] + warp_x * strength,
    p[1] + warp_y * strength,
    p[2] + warp_z * strength,
    p[3] + warp_w * strength,
  ]
  fbm4d(warped, octaves, persistence, lacunarity, perm, grads, 1)
}

