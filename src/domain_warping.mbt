fn clamp(x: Float, min: Float, max: Float) -> Float {
  if x < min { min }
  else if x > max { max }
  else { x }
}
let maxwarp : Ref[Float] = { val: 2.0 }

pub fn new_maxwarp(a : Float) -> Float {
  if a < 0 {
    return maxwarp.val
  }
  maxwarp.val = a
  maxwarp.val
}
fn warp2d(
  grads : Array[Array[Float]],
  p : Array[Float],
  seed : Int,
  scale : Float,
  strength : Float
) -> Float {
  let perm = init_noise(seed)
  let warp_x = simplex2d([p[0], p[1]], perm, grads, scale)
  let warp_y = simplex2d([p[0] + 19.19, p[1] + 29.29], perm, grads, scale)
  let limit = maxwarp.val
  let warped = [
    clamp(p[0] + warp_x * strength, p[0] - limit, p[0] + limit),
    clamp(p[1] + warp_y * strength, p[1] - limit, p[1] + limit),
  ]
  maxwarp.val = 2.0 // 重置为默认值
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
  let limit = maxwarp.val
  let warped = [
    clamp(p[0] + warp_x * strength, p[0] - limit, p[0] + limit),
    clamp(p[1] + warp_y * strength, p[1] - limit, p[1] + limit),
  ]
  maxwarp.val = 2.0
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
  grads : Array[Array[Float]],
  p : Array[Float],
  seed : Int,
  scale : Float,
  strength : Float
) -> Float {
  let perm = init_noise(seed)
  let warp_x = simplex3d([p[0], p[1], p[2]], perm, grads, scale)
  let warp_y = simplex3d(
    [p[0] + 19.19, p[1] + 29.29, p[2] + 37.37],
    perm,
    grads,
    scale,
  )
  let warp_z = simplex3d(
    [p[0] + 41.41, p[1] + 53.53, p[2] + 67.67],
    perm,
    grads,
    scale,
  )
  let limit = maxwarp.val
  let warped = [
    clamp(p[0] + warp_x * strength, p[0] - limit, p[0] + limit),
    clamp(p[1] + warp_y * strength, p[1] - limit, p[1] + limit),
    clamp(p[2] + warp_z * strength, p[2] - limit, p[2] + limit),
  ]
  maxwarp.val = 2.0
  simplex3d(warped, perm, grads, 1)
}



fn warp_fbm3d(
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
  let warp_x = fbm3d(
    [p[0], p[1], p[2]],
    octaves,
    persistence,
    lacunarity,
    perm,
    grads,
    scale,
  )
  let warp_y = fbm3d(
    [p[0] + 19.19, p[1] + 29.29, p[2] + 37.37],
    octaves,
    persistence,
    lacunarity,
    perm,
    grads,
    scale,
  )
  let warp_z = fbm3d(
    [p[0] + 41.41, p[1] + 53.53, p[2] + 67.67],
    octaves,
    persistence,
    lacunarity,
    perm,
    grads,
    scale,
  )
  let limit = maxwarp.val
  let warped = [
    clamp(p[0] + warp_x * strength, p[0] - limit, p[0] + limit),
    clamp(p[1] + warp_y * strength, p[1] - limit, p[1] + limit),
    clamp(p[2] + warp_z * strength, p[2] - limit, p[2] + limit),
  ]
  maxwarp.val = 2.0
  fbm3d(warped, octaves, persistence, lacunarity, perm, grads, 1)
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
  let limit = maxwarp.val
  let warped = [
    clamp(p[0] + warp_x * strength, p[0] - limit, p[0] + limit),
    clamp(p[1] + warp_y * strength, p[1] - limit, p[1] + limit),
    clamp(p[2] + warp_z * strength, p[2] - limit, p[2] + limit),
    clamp(p[3] + warp_w * strength, p[3] - limit, p[3] + limit),
  ]
  maxwarp.val = 2.0
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
  let limit = maxwarp.val
  let warped = [
    clamp(p[0] + warp_x * strength, p[0] - limit, p[0] + limit),
    clamp(p[1] + warp_y * strength, p[1] - limit, p[1] + limit),
    clamp(p[2] + warp_z * strength, p[2] - limit, p[2] + limit),
    clamp(p[3] + warp_w * strength, p[3] - limit, p[3] + limit),
  ]
  maxwarp.val = 2.0
  fbm4d(warped, octaves, persistence, lacunarity, perm, grads, 1)
}


