#pragma once

#include <ATen/ATen.h>

#include <c10/core/Allocator.h>
#include <c10/util/ThreadLocalDebugInfo.h>

class TestMemoryReportingInfo : public c10::MemoryReportingInfoBase {
 public:
  struct Record {
    void* ptr;
    int64_t alloc_size;
    int64_t allocated_size;
    int64_t reserved_size;
    c10::Device device;
  };

  std::vector<Record> records;

  TestMemoryReportingInfo() {}
  virtual ~TestMemoryReportingInfo() {}

  void reportMemoryUsage(
      void* ptr,
      int64_t alloc_size,
      int64_t allocated_size,
      int64_t reserved_size,
      c10::Device device) override {
    records.emplace_back(
        Record{ptr, alloc_size, allocated_size, reserved_size, device});
  }

  bool memoryProfilingEnabled() const override {
    return true;
  }

  Record getLatestRecord() {
    return records.back();
  }
};
