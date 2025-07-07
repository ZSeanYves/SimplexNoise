test "Basic Simplex Noise Image" {
  let (_, grads) = @ZSeanYves/SimplexNoise.create_simplex_noise(42)
  //父目录写法按系统自行调整，这里及下面默认按windows路径
  let ok = @ZSeanYves/SimplexNoise.generate_and_save_noise_image("./src/examples/gray/basic_noise.png", 256, 256, 0.05, 42, grads)
  assert_eq(ok,true)
}


test "fBm Noise Image (Cloud/Heightmap)" {
  let config = @ZSeanYves/SimplexNoise.new_NoiseConfig(5, 0.5, 2.0, 0.03)
  let (_, grads) = create_simplex_noise(123)
  let ok = @ZSeanYves/SimplexNoise.generate_and_save_fbm_image("./src/examples/gray/fbm_noise.png", 256, 256, 123, grads, config)
  assert_eq(ok,true)
}

test "Basic Simplex Noise Image (Color)" {
  let (_, grads) = create_simplex_noise(42)
  let ok = @ZSeanYves/SimplexNoise.generate_and_save_noise_image_color("./src/examples/color/basic_noise_color.png", 256, 256, 0.05, 42, grads)
  assert_eq(ok, true)
}

test "fBm Noise Image (Color)" {
  let config = new_NoiseConfig(5, 0.5, 2.0, 0.03)
  let (_, grads) = create_simplex_noise(123)
  let ok = @ZSeanYves/SimplexNoise.generate_and_save_fbm_image_color("./src/examples/color/fbm_noise_color.png", 256, 256, 123, grads, config)
  assert_eq(ok, true)
}


test "Permutation Table Initialization" {
  let (perm, _) = create_simplex_noise(7)
  assert_eq(perm.length(), 512)  
  assert_eq(perm[0] >= 0 && perm[0] < 256,true)
}

test "Gradient Vector Validity" {
  for g in grads {
    let len = (g[0] * g[0] + g[1] * g[1]).sqrt()
    assert_eq(len >= 0.9 && len <= 1.1,true)  // 梯度噪声向量
  }
}

test "2D Simplex Noise Output Range" {
  let (perm, _) = create_simplex_noise(99)
  for i in 0..<100 {
    for j in 0..<100 {
      let val = noise2d([i.to_float() * 0.05, j.to_float() * 0.05], perm, grads)
      assert_eq(val >= -1.1 && val <= 1.1,true)  // 理论范围 [-1, 1]，考虑浮点误差
    }
  }
}

test "Single Vertex Contribution Debug" {
  let (perm, _) = create_simplex_noise(1)
  let c = @ZSeanYves/SimplexNoise.simplex2d_debug([0.1, 0.1], perm, grads)

  // 可根据观察值补充 assert
  assert_eq(c[0] >= -1.0 && c[0] <= 1.0,true)
  assert_eq(c[1] >= -1.0 && c[1] <= 1.0,true)
  assert_eq(c[2] >= -1.0 && c[2] <= 1.0,true)
}
