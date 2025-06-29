// 预定义 8 个 2D 单位向量作为梯度集合
pub const gradients : Array[Vector[Float]] = [
  Vector::from_array([1.0, 0.0]),
  Vector::from_array([-1.0, 0.0]),
  Vector::from_array([0.0, 1.0]),
  Vector::from_array([0.0, -1.0]),
  Vector::from_array([1.0, 1.0]),
  Vector::from_array([-1.0, 1.0]),
  Vector::from_array([1.0, -1.0]),
  Vector::from_array([-1.0, -1.0])
]
