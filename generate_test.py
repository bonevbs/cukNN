#!/usr/bin/python
import numpy as np

# data will come from a mixture of Gaussians
K = 3 # number of classes will be 2
D = 2 # dimension will be 2
pi = []
mu = []
sigma = []
for k in range(0,K):
  pi.append(np.random.rand())
  mu.append(10.*np.random.rand(D))
  a = np.random.standard_exponential((D,D))
  a = np.tril(a) + np.tril(a, -1).T # this ensures that we are using the same distribution
  sigma.append(a.T@a)
s = sum(pi); pi = [p/s for p in pi]

def sample(n : int):
  t = np.random.choice(range(0,K), size=(n, ), p=pi)
  x = [np.random.multivariate_normal(mu[c], sigma[c]) for c in t]
  return np.array(x), np.array(t)  


# generate the actual data
x, t = sample(400)

with open('output.npy', 'wb+') as outfile:
    np.save(outfile, x)
    np.save(outfile, t)