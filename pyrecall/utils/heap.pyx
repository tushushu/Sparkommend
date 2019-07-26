# distutils: language = c++
# cython: boundscheck=False
# cython: wraparound=False

"""
@Author: tushushu
@Date: 2019-07-09 10:45:25
"""

from libcpp cimport bool
from libcpp.utility cimport pair
from libcpp.vector cimport vector
from libcpp.algorithm cimport pop_heap, push_heap


cdef bool min_cmp(const pair[int, float]& element1, const pair[int, float]& element2):
    """比较小顶堆两个元素的大小，其中.first为元素的名称，.second为元素的值。"""
    return element1.second > element2.second


cdef bool max_cmp(const pair[int, float]& element1, const pair[int, float]& element2):
    """比较大顶堆两个元素的大小，其中.first为元素的名称，.second为元素的值。"""
    return element1.second < element2.second


cdef void heappush(vector[pair[int, float]]& heap, unsigned int max_size, const pair[int, float]& element
                   , bool (*cmp)(const pair[int, float]&, const pair[int, float]&)) except *:
    """将元素Push到堆中，保持堆的特性，且元素个数不超过max_size。"""
    if heap.size() == max_size:
        if cmp(element, heap.front()):
            heap.push_back(element)
            pop_heap(heap.begin(), heap.end(), cmp)
            heap.pop_back()
    else:
        heap.push_back(element)
        push_heap(heap.begin(), heap.end(), cmp)


cdef void min_heappush(vector[pair[int, float]]& heap, unsigned int max_size, const pair[int, float]& element) except *:
    """将元素Push到小顶堆中，保持堆的特性，且元素个数不超过max_size。"""
    heappush(heap, max_size, element, min_cmp)


cdef void max_heappush(vector[pair[int, float]]& heap, unsigned int max_size, const pair[int, float]& element) except *:
    """将元素Push到大顶堆中，保持堆的特性，且元素个数不超过max_size。"""
    heappush(heap, max_size, element, max_cmp)


def min_heappush_py(heap: list, max_size: int, element: tuple)->list:
    """包装min_heappush函数给Python程序调用。"""
    cdef vector[pair[int, float]] heap_cpp = heap
    min_heappush(heap_cpp, max_size, element)
    return heap_cpp
