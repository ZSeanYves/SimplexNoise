// octaves: 八度数，决定叠加层数
// persistence: 振幅衰减因子
// lacunarity: 频率增长因子
pub fn fbm2d(
  p : Array[Float],
  octaves : Int,
  persistence : Float,
  lacunarity : Float,
  perm_table : Array[Int],
  grads : Array[Array[Float]]
) -> Float {
  let mut total = 0.0
  let mut frequency = 1.0
  let mut amplitude = 1.0
  let mut max_amplitude = 0.0
  for _ in 0..<octaves {
    let scaled_p = [p[0] * frequency.to_float(), p[1] * frequency.to_float()]
    total += (simplex2d(scaled_p, perm_table, grads) * amplitude.to_float()).to_double()
    max_amplitude += amplitude
    amplitude *= persistence.to_double()
    frequency *= lacunarity.to_double()
  }
  (total / max_amplitude).to_float()
}

pub fn fbm3d(
  p : Array[Float],
  octaves : Int,
  persistence : Float,
  lacunarity : Float,
  perm_table : Array[Int],
  grads : Array[Array[Float]]
) -> Float {
  let mut total = 0.0
  let mut amplitude = 1.0
  let mut frequency = 1.0
  let mut max_amplitude = 0.0

  for _ in 0..<octaves {
    let sample = [p[0] * frequency.to_float(), p[1] * frequency.to_float(), p[2] * frequency.to_float()]
    total += (simplex3d(sample, perm_table, grads) * amplitude.to_float()).to_double()
    max_amplitude = max_amplitude + amplitude

    amplitude = amplitude * persistence.to_double()
    frequency = frequency * lacunarity.to_double()
  }

  (total / max_amplitude).to_float()
}
