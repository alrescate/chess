/*
 * HRand.h
 *
 *  Created on: Jun 1, 2019
 *      Author: henry
 */

#include <stdint.h>

#ifndef __HRAND_H
#define __HRAND_H
class HRand {
  private:
    uint32_t a[55], j;
  public:
    uint32_t mult(uint32_t p, uint32_t q);
    HRand(uint32_t seed = 0);
    uint32_t next(uint32_t r);
};
#endif
