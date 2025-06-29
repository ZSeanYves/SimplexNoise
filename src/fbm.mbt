// octaves: 八度数，决定叠加层数
// persistence: 振幅衰减因子
// lacunarity: 频率增长因子
pub fn fbm2d(p: @la.Vector[Float], octaves: Int, persistence: Float, lacunarity: Float) -> Float {
  var total = 0.0
  var frequency = 1.0
  var amplitude = 1.0
  var max_amplitude = 0.0

  for _ in 0..octaves {
    let scaled_p = p * frequency
    total += noise2d::simplex2d(scaled_p) * amplitude

    max_amplitude += amplitude
    amplitude *= persistence
    frequency *= lacunarity
  }

  // 归一化到 [-1, 1]
  total / max_amplitude
}
