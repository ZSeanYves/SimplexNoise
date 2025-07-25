fn simplex4d(
  p: Array[Float],
  perm_table: Array[Int],
  grads: Array[Array[Float]],
  scale: Float 
) -> Float {
  let f4 = (@math.sqrt(5.0) - 1.0) / 4.0
  let g4 = (5.0 - @math.sqrt(5.0)) / 20.0

  let nx = p[0] * scale
  let ny = p[1] * scale
  let nz = p[2] * scale
  let nw = p[3] * scale

  let s = (nx + ny + nz + nw) * f4.to_float()
  let i = @math.floor(nx.to_double() + s.to_double()).to_int()
  let j = @math.floor(ny.to_double() + s.to_double()).to_int()
  let k = @math.floor(nz.to_double() + s.to_double()).to_int()
  let l = @math.floor(nw.to_double() + s.to_double()).to_int()
  let t = (i + j + k + l).to_float() * g4.to_float()
  let x0 = nx - (i.to_float() - t)
  let y0 = ny - (j.to_float() - t)
  let z0 = nz - (k.to_float() - t)
  let w0 = nw - (l.to_float() - t)

  // 确定 4D 单纯形内部次序
  let rank = [0, 0, 0, 0]
  if x0 > y0 {
    rank[0] += 1
  } else {
    rank[1] += 1
  }
  if x0 > z0 {
    rank[0] += 1
  } else {
    rank[2] += 1
  }
  if x0 > w0 {
    rank[0] += 1
  } else {
    rank[3] += 1
  }
  if y0 > z0 {
    rank[1] += 1
  } else {
    rank[2] += 1
  }
  if y0 > w0 {
    rank[1] += 1
  } else {
    rank[3] += 1
  }
  if z0 > w0 {
    rank[2] += 1
  } else {
    rank[3] += 1
  }

  let i1 = if rank[0] >= 3 { 1 } else { 0 }
  let j1 = if rank[1] >= 3 { 1 } else { 0 }
  let k1 = if rank[2] >= 3 { 1 } else { 0 }
  let l1 = if rank[3] >= 3 { 1 } else { 0 }
  let i2 = if rank[0] >= 2 { 1 } else { 0 }
  let j2 = if rank[1] >= 2 { 1 } else { 0 }
  let k2 = if rank[2] >= 2 { 1 } else { 0 }
  let l2 = if rank[3] >= 2 { 1 } else { 0 }
  let i3 = if rank[0] >= 1 { 1 } else { 0 }
  let j3 = if rank[1] >= 1 { 1 } else { 0 }
  let k3 = if rank[2] >= 1 { 1 } else { 0 }
  let l3 = if rank[3] >= 1 { 1 } else { 0 }

  // 四个顶点偏移
  let x1 = x0 - i1.to_float() + g4.to_float()
  let y1 = y0 - j1.to_float() + g4.to_float()
  let z1 = z0 - k1.to_float() + g4.to_float()
  let w1 = w0 - l1.to_float() + g4.to_float()
  let x2 = x0 - i2.to_float() + 2.0 * g4.to_float()
  let y2 = y0 - j2.to_float() + 2.0 * g4.to_float()
  let z2 = z0 - k2.to_float() + 2.0 * g4.to_float()
  let w2 = w0 - l2.to_float() + 2.0 * g4.to_float()
  let x3 = x0 - i3.to_float() + 3.0 * g4.to_float()
  let y3 = y0 - j3.to_float() + 3.0 * g4.to_float()
  let z3 = z0 - k3.to_float() + 3.0 * g4.to_float()
  let w3 = w0 - l3.to_float() + 3.0 * g4.to_float()
  let x4 = x0 - 1.0 + 4.0 * g4.to_float()
  let y4 = y0 - 1.0 + 4.0 * g4.to_float()
  let z4 = z0 - 1.0 + 4.0 * g4.to_float()
  let w4 = w0 - 1.0 + 4.0 * g4.to_float()

  // 计算四个角落的梯度索引
  let gi0 = hash4d(i, j, k, l, perm_table, grads)
  let gi1 = hash4d(i + i1, j + j1, k + k1, l + l1, perm_table, grads)
  let gi2 = hash4d(i + i2, j + j2, k + k2, l + l2, perm_table, grads)
  let gi3 = hash4d(i + i3, j + j3, k + k3, l + l3, perm_table, grads)
  let gi4 = hash4d(i + 1, j + 1, k + 1, l + 1, perm_table, grads)

  let mut n0 = 0.0
  let mut n1 = 0.0
  let mut n2 = 0.0
  let mut n3 = 0.0
  let mut n4 = 0.0
  let t0 = 0.6 - (x0 * x0 + y0 * y0 + z0 * z0 + w0 * w0).to_double()
  if t0 >= 0.0 {
    let t0_2 = t0 * t0
    n0 = t0_2 * t0_2 * (gi0[0] * x0 + gi0[1] * y0 + gi0[2] * z0 + gi0[3] * w0).to_double()
  }
  let t1 = 0.6 - (x1 * x1 + y1 * y1 + z1 * z1 + w1 * w1).to_double()
  if t1 >= 0.0 {
    let t1_2 = t1 * t1
    n1 = t1_2 * t1_2 * (gi1[0] * x1 + gi1[1] * y1 + gi1[2] * z1 + gi1[3] * w1).to_double()
  }
  let t2 = 0.6 - (x2 * x2 + y2 * y2 + z2 * z2 + w2 * w2).to_double()
  if t2 >= 0.0 {
    let t2_2 = t2 * t2
    n2 = t2_2 * t2_2 * (gi2[0] * x2 + gi2[1] * y2 + gi2[2] * z2 + gi2[3] * w2).to_double()
  }
  let t3 = 0.6 - (x3 * x3 + y3 * y3 + z3 * z3 + w3 * w3).to_double()
  if t3 >= 0.0 {
    let t3_2 = t3 * t3
    n3 = t3_2 * t3_2 * (gi3[0] * x3 + gi3[1] * y3 + gi3[2] * z3 + gi3[3] * w3).to_double()
  }
  let t4 = 0.6 - (x4 * x4 + y4 * y4 + z4 * z4 + w4 * w4).to_double()
  if t4 >= 0.0 {
    let t4_2 = t4 * t4
    n4 = t4_2 * t4_2 * (gi4[0] * x4 + gi4[1] * y4 + gi4[2] * z4 + gi4[3] * w4).to_double()
  }

  27.0 * (n0 + n1 + n2 + n3 + n4).to_float() // 归一化
}

