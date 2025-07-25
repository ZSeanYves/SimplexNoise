// 初始化置换表，基于种子打乱
fn init_noise(seed: Int) -> Array[Int] {
  let perm_table = init_permutation(seed)
  
  //重复一遍 0..255 填充，构建最终长度 512 的置换表
  let result = [..perm_table, ..perm_table]
  result
}
fn hash(
  ix : Int,
  iy : Int,
  perm_table : Array[Int],
  grads : Array[Array[Float]]
) -> Array[Float] {
  let idx = perm_table[(perm_table[ix & 255] + iy) & 255] % grads.length()
  grads[idx]
}


// 2D Simplex Noise 核心函数
fn simplex2d(
  p : Array[Float], 
  perm_table : Array[Int], 
  grads : Array[Array[Float]], 
  scale: Float // 频率控制
) -> Float {
  let f2 = 0.5 * (@math.sqrt(3.0) - 1.0)
  let g2 = (3.0 - @math.sqrt(3.0)) / 6.0

  // 频率控制
  let nx = p[0] * scale
  let ny = p[1] * scale

  let s = (nx + ny).to_double() * f2
  let i = @math.floor(nx.to_double() + s).to_int()
  let j = @math.floor(ny.to_double() + s).to_int()
  let t = (i.to_float() + j.to_float()) * g2.to_float()

  let x0 = nx - (i.to_float() - t)
  let y0 = ny - (j.to_float() - t)
  let (i1, j1) = if x0 > y0 { (1, 0) } else { (0, 1) }
  let x1 = x0 - (i1.to_double() + g2).to_float()
  let y1 = y0 - (j1.to_double() + g2).to_float()
  let x2 = x0 - 1.0 + 2.0 * g2.to_float()
  let y2 = y0 - 1.0 + 2.0 * g2.to_float()

  let gi0 = hash(i, j, perm_table, grads)
  let gi1 = hash(i + i1, j + j1, perm_table, grads)
  let gi2 = hash(i + 1, j + 1, perm_table, grads)

  let mut n0 = 0.0
  let mut n1 = 0.0
  let mut n2 = 0.0

  let t0 = 0.5 - (x0 * x0 + y0 * y0).to_double()
  if t0 >= 0.0 {
    let t0_2 = t0 * t0
    n0 = t0_2 * t0_2 * (gi0[0] * x0 + gi0[1] * y0).to_double()
  }

  let t1 = 0.5 - (x1 * x1 + y1 * y1).to_double()
  if t1 >= 0.0 {
    let t1_2 = t1 * t1
    n1 = t1_2 * t1_2 * (gi1[0] * x0 + gi1[1] * y0).to_double()
  }

  let t2 = 0.5 - (x2 * x2 + y2 * y2).to_double()
  if t2 >= 0.0 {
    let t2_2 = t2 * t2
    n2 = t2_2 * t2_2 * (gi2[0] * x0 + gi2[1] * y0).to_double()
  }

  // 缩放到 [-1, 1] 范围
  20 * (n0 + n1 + n2).to_float()
}


