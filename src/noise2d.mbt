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
  grads : Array[Array[Float]]
) -> Float {
  let f2 = 0.5 * (@math.sqrt(3.0) - 1.0)
  let g2 = (3.0 - @math.sqrt(3.0)) / 6.0
  let s = (p[0] + p[1]).to_double() * f2
  let i = @math.floor(p[0].to_double() + s).to_int()
  let j = @math.floor(p[1].to_double() + s).to_int()
  let t = (i.to_float() + j.to_float()) * g2.to_float()
  let x0 = p[0] - (i.to_float() - t)
  let y0 = p[1] - (j.to_float() - t)
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
  20.0 * (n0 + n1 + n2).to_float() // 缩放到 [-1, 1] 范围
}


pub fn simplex2d_debug(
  p : Array[Float],
  perm_table : Array[Int],
  grads : Array[Array[Float]]
) -> Array[Float] {
  let f2 = 0.5 * (@math.sqrt(3.0) - 1.0)
  let g2 = (3.0 - @math.sqrt(3.0)) / 6.0
  let s = (p[0] + p[1]).to_double() * f2
  let i = @math.floor(p[0].to_double() + s).to_int()
  let j = @math.floor(p[1].to_double() + s).to_int()
  let t = (i.to_float() + j.to_float()) * g2.to_float()
  let x0 = p[0] - (i.to_float() - t)
  let y0 = p[1] - (j.to_float() - t)
  let (i1, j1) = if x0 > y0 { (1, 0) } else { (0, 1) }
  let x1 = x0 - (i1.to_double() + g2).to_float()
  let y1 = y0 - (j1.to_double() + g2).to_float()
  let x2 = x0 - 1.0 + 2.0 * g2.to_float()
  let y2 = y0 - 1.0 + 2.0 * g2.to_float()
  let gi0 = hash(i, j, perm_table, grads)
  let gi1 = hash(i + i1, j + j1, perm_table, grads)
  let gi2 = hash(i + 1, j + 1, perm_table, grads)
  let mut contrib0 = 0.0
  let mut contrib1 = 0.0
  let mut contrib2 = 0.0
  let t0 = 0.5 - (x0 * x0 + y0 * y0).to_double()
  if t0 >= 0.0 {
    let t0_2 = t0 * t0
    contrib0 = t0_2 * t0_2 * (gi0[0] * x0 + gi0[1] * y0).to_double()
  }
  let t1 = 0.5 - (x1 * x1 + y1 * y1).to_double()
  if t1 >= 0.0 {
    let t1_2 = t1 * t1
    contrib1 = t1_2 * t1_2 * (gi1[0] * x1 + gi1[1] * y1).to_double()
  }
  let t2 = 0.5 - (x2 * x2 + y2 * y2).to_double()
  if t2 >= 0.0 {
    let t2_2 = t2 * t2
    contrib2 = t2_2 * t2_2 * (gi2[0] * x2 + gi2[1] * y2).to_double()
  }
  let contribute = [
    contrib0.to_float(),
    contrib1.to_float(),
    contrib2.to_float(),
  ]
  contribute
}
