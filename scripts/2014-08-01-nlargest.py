from heapq import heappush, heapreplace

def k_largest(seq, k):
    """number of items in seq is much larger than k
       return the k-th largest
    """
    it = iter(seq)
    heap = [] # keeps the argest k items
    for i in range(k):
        heappush(heap, next(it))
    for item in it:
        if item > heap[0]:
            heapreplace(heap, item)
    return heap[0]
