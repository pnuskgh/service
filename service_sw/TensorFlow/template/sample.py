import os
import inspect
import tensorflow as tf

print(os.path.dirname(inspect.getfile(tf)))


hello = tf.constant('Hello, TensorFlow!')
sess = tf.Session()
print(sess.run(hello))

a = tf.constant(10)
b = tf.constant(32)
print(sess.run(a + b)) 

