let perm_table : Array[Int] = Array::make(512, 0)

// 初始化置换表，基于种子打乱
pub fn init_permutation(seed: Int) {
  let rng = random::new(seed)
  let base = Array::from_range(0, 255)
  let shuffled = random::shuffle(base, rng)
  for i in 0..255 {
    perm_table[i] = shuffled[i]
    perm_table[i + 256] = shuffled[i]
  }
}

fn hash(ix: Int, iy: Int) -> @la.Vector[Float] {
  let idx = perm_table[(perm_table[ix & 255] + iy) & 255] % gradients.length()
  gradients[idx]
}

// 2D Simplex Noise 核心函数
pub fn simplex2d(p: @la.Vector[Float]) -> Float {
  let F2 = 0.5 * (Math::sqrt(3.0) - 1.0)
  let G2 = (3.0 - Math::sqrt(3.0)) / 6.0

  let s = (p.data[0] + p.data[1]) * F2
  let i = Math::floor(p.data[0] + s)
  let j = Math::floor(p.data[1] + s)

  let t = (i + j) * G2
  let x0 = p.data[0] - (i - t)
  let y0 = p.data[1] - (j - t)

  let (i1, j1) = if x0 > y0 { (1, 0) } else { (0, 1) }

  let x1 = x0 - i1 + G2
  let y1 = y0 - j1 + G2
  let x2 = x0 - 1.0 + 2.0 * G2
  let y2 = y0 - 1.0 + 2.0 * G2

  let gi0 = hash(i, j)
  let gi1 = hash(i + i1, j + j1)
  let gi2 = hash(i + 1, j + 1)

  var n0 = 0.0
  var n1 = 0.0
  var n2 = 0.0

  let t0 = 0.5 - x0 * x0 - y0 * y0
  if t0 >= 0.0 {
    let t0_2 = t0 * t0
    n0 = t0_2 * t0_2 * gi0.dot(@la.Vector::from_array([x0, y0]))
  }

  let t1 = 0.5 - x1 * x1 - y1 * y1
  if t1 >= 0.0 {
    let t1_2 = t1 * t1
    n1 = t1_2 * t1_2 * gi1.dot(@la.Vector::from_array([x1, y1]))
  }

  let t2 = 0.5 - x2 * x2 - y2 * y2
  if t2 >= 0.0 {
    let t2_2 = t2 * t2
    n2 = t2_2 * t2_2 * gi2.dot(@la.Vector::from_array([x2, y2]))
  }

  70.0 * (n0 + n1 + n2)
}
