/*
 * HRand.cpp
 *
 *  Created on: Jun 1, 2019
 *      Author: henry
 */

#include <HRand.h>
// see "Algorithms" by R. Sedgewick, 2nd ed., page 513, translated here from Pascal to C++
uint32_t HRand::mult(uint32_t p, uint32_t q) {
  uint32_t p1, p0, q1, q0;
  p1 = p / 10000; p0 = p % 10000;
  q1 = q / 10000; q0 = q % 10000;
  return (((p0*q1+p1*q0) % 10000)*10000+p0*q0) % 100000000;
}
HRand::HRand(uint32_t seed) {
  const uint32_t b = 31415821;
  a[0] = seed;
  for (j = 1; j <= 54; j++) {
    a[j] = (mult(a[j-1], b) + 1) % 100000000;
  }
}
uint32_t HRand::next(uint32_t r) { // will not function for r > 10000
  j = (j+1) % 55;
  a[j] = (a[(j+23) % 55] + a[(j+54) & 55]) % 100000000;
  return ((a[j]/10000)*r)/10000;

}
