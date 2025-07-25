// octaves: 八度数，决定叠加层数
// persistence: 振幅衰减因子
// lacunarity: 频率增长因子
pub fn fbm2d(
  p : Array[Float],
  octaves : Int,
  persistence : Float,
  lacunarity : Float,
  perm_table : Array[Int],
  grads : Array[Array[Float]],
  base_scale : Float // 初始频率
) -> Float {
  let mut total = 0.0
  let mut amplitude = 1.0
  let mut scale = base_scale
  let mut max_amplitude = 0.0

  for _ in 0..<octaves {
    total += simplex2d(p, perm_table, grads, scale).to_double() * amplitude
    max_amplitude += amplitude
    amplitude *= persistence.to_double()
    scale *= lacunarity
  }

  (total / max_amplitude).to_float()
}



pub fn fbm3d(
  p: Array[Float],
  octaves: Int,
  persistence: Float,
  lacunarity: Float,
  perm_table: Array[Int],
  grads: Array[Array[Float]],
  base_scale: Float,
) -> Float {
  let mut total = 0.0
  let mut amplitude = 1.0
  let mut scale = base_scale
  let mut max_amplitude = 0.0

  for _ in 0..<octaves {
    total += simplex3d(p, perm_table, grads, scale).to_double() * amplitude
    max_amplitude += amplitude
    amplitude *= persistence.to_double()
    scale *= lacunarity
  }

  (total / max_amplitude).to_float()
}

pub fn fbm4d(
  p: Array[Float],
  octaves: Int,
  persistence: Float,
  lacunarity: Float,
  perm_table: Array[Int],
  grads: Array[Array[Float]],
  base_scale: Float,
) -> Float {
  let mut total = 0.0
  let mut amplitude = 1.0
  let mut scale = base_scale
  let mut max_amplitude = 0.0

  for _ in 0..<octaves {
    total += simplex4d(p, perm_table, grads, scale).to_double() * amplitude
    max_amplitude += amplitude
    amplitude *= persistence.to_double()
    scale *= lacunarity
  }

  (total / max_amplitude).to_float()
}




