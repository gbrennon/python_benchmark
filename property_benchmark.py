import time

class Entity:
    def __init__(self):
        self._id = 123
    @property
    def id(self):
        return self._id

entity = Entity()
N = 10_000_000

#_ = entity.id

start = time.perf_counter()
for _ in range(N):
    entity._id
end = time.perf_counter()
print(f"Direct attribute: {(end - start):.4f} seconds")

start = time.perf_counter()
for _ in range(N):
    entity.id
end = time.perf_counter()
print(f"Property access: {(end - start):.4f} seconds")
