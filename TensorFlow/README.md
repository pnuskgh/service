TensorFlow (www.tensorflow.org) 0.11.0  
Python 2.7.5 (pip 9.0.1) + C++  

* Perceptron

* y = h(b + Wx)
  * y : Label
  * Activation function (활성화 함수, h(x))
    * Step function (계단 함수)
    * Sigmoid function : 1 / (1 + exp(-x))
    * ReLU (Rectified Linear Unit) function : maximum(0, x)
  * 출력층의 활성화 함수
    * 회귀 (Regression)   : Identity function (항등 함수) - return a
    * 분류 (Classfication): Softmax - return exp(a) / sum(exp(a))
  * b : Bias (편향)
  * W : Weight (가중치)
  * x : 입력 신호

* 용어 사전
  * ML (Machine Learning)
    * Supervised Learning
    * Unsupervised Learning
  * Train

* 참고 문헌
  * https://www.tensorflow.org/
  * https://www.facebook.com/groups/TensorFlowKR/
  * https://www.continuum.io/downloads
  * https://tensorflowkorea.gitbooks.io/tensorflow-kr/g3doc/get_started/

* 참고 문헌 - Source
  * https://github.com/WegraLee/TensorFlow-Tutorials
  * https://github.com/WegraLee/deep-learning-from-scratch
  * https://github.com/hunkim/DeepLearningZeroToAll/

