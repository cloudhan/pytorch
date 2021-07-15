load("@rules_cc//cc:defs.bzl", "cc_library")
load("@//tools/rules:cu.bzl", "cu_library")
load("@//third_party:substitution.bzl", "template_rule")
load(
    "@//tools/config:defs.bzl",
    "if_cuda",
    "if_msvc",
)

template_rule(
    name = "gloo_config_cmake_macros",
    src = "gloo/config.h.in",
    out = "gloo/config.h",
    substitutions = {
        "@GLOO_VERSION_MAJOR@": "0",
        "@GLOO_VERSION_MINOR@": "5",
        "@GLOO_VERSION_PATCH@": "0",
        "cmakedefine01 GLOO_USE_CUDA": "define GLOO_USE_CUDA 1",
        "cmakedefine01 GLOO_USE_NCCL": "define GLOO_USE_NCCL 0",
        "cmakedefine01 GLOO_USE_ROCM": "define GLOO_USE_ROCM 0",
        "cmakedefine01 GLOO_USE_RCCL": "define GLOO_USE_RCCL 0",
        "cmakedefine01 GLOO_USE_REDIS": "define GLOO_USE_REDIS 0",
        "cmakedefine01 GLOO_USE_IBVERBS": "define GLOO_USE_IBVERBS 0",
        "cmakedefine01 GLOO_USE_MPI": "define GLOO_USE_MPI 0",
        "cmakedefine01 GLOO_USE_AVX": "define GLOO_USE_AVX 0",
        "cmakedefine01 GLOO_USE_LIBUV": "define GLOO_USE_LIBUV 0",
        "cmakedefine01 GLOO_HAVE_TRANSPORT_TCP": "define GLOO_HAVE_TRANSPORT_TCP 1",
        "cmakedefine01 GLOO_HAVE_TRANSPORT_IBVERBS": "define GLOO_HAVE_TRANSPORT_IBVERBS 0",
        "cmakedefine01 GLOO_HAVE_TRANSPORT_UV": "define GLOO_HAVE_TRANSPORT_UV 0",
    },
)

GLOO_SRCS = glob(
    [
        "*.cc",
    ],
    exclude = [
        "cuda*.cc",
        "hip*.cc",
    ],
)

GLOO_HDRS = ["gloo/config.h"] + glob(
    [
        "*.h",
    ],
    exclude = [
        "cuda*.h",
        "hip*.h",
    ],
)

GLOO_CUDA_SRCS = glob(
    [
        "*.cu",
        "cuda*.cc",
    ],
)

GLOO_CUDA_HDRS = glob(["cuda*.h"])

GLOO_COMMON_SRCS = [
    "gloo/common/logging.cc",
]

GLOO_COMMON_HDRS = [
    "gloo/common/aligned_allocator.h",
    "gloo/common/common.h",
    "gloo/common/error.h",
    "gloo/common/logging.h",
    "gloo/common/string.h",
]

GLOO_COMMON_SRCS_LINUX = [
    "gloo/common/linux.cc",
]

GLOO_COMMON_HDRS_LINUX = [
    "gloo/common/linux.h",
    "gloo/common/linux_devices.h",
]

GLOO_COMMON_SRCS_WIN = [
    "gloo/common/win.cc",
]

GLOO_COMMON_HDRS_WIN = [
    "gloo/common/win.h",
]

GLOO_MPI_SRCS = [
    "gloo/mpi/context.cc",
]

GLOO_MPI_HDRS = [
    "gloo/mpi/context.h",
]

GLOO_NCCL_SRCS = [
    "gloo/nccl/nccl.cu",
]

GLOO_NCCL_HDRS = [
    "gloo/nccl/nccl.h",
]

GLOO_RENDEZVOUS_SRCS = glob(
    [
        "gloo/rendezvous/*.cc",
    ],
    exclude = [
        "gloo/rendezvous/redis_store.cc",
    ],
)

GLOO_RENDEZVOUS_HDRS = glob(
    [
        "gloo/rendezvous/*.h",
    ],
    exclude = [
        "gloo/rendezvous/redis_store.h",
    ],
)

GLOO_TRANSPORT_SRCS = glob(["gloo/transport/*.cc"])

GLOO_TRANSPORT_HDRS = glob(["gloo/transport/*.h"])

GLOO_IBVERBS_SRCS = glob(["gloo/transport/ibverbs/*.cc"])

GLOO_IBVERBS_HDRS = glob(["gloo/transport/ibverbs/*.h"])

GLOO_TCP_SRCS = glob(["gloo/transport/tcp/**/*.cc"])

GLOO_TCP_HDRS = glob(["gloo/transport/tcp/**/*.h"])

GLOO_UV_SRCS = glob(["gloo/transport/uv/*.cc"])

GLOO_UV_HDRS = glob(["gloo/transport/uv/*.h"])

cc_library(
    name = "gloo_headers",
    hdrs = GLOO_HDRS + GLOO_COMMON_HDRS + if_msvc(GLOO_COMMON_HDRS_WIN, GLOO_COMMON_HDRS_LINUX) + GLOO_RENDEZVOUS_HDRS + GLOO_TRANSPORT_HDRS + if_msvc([], GLOO_TCP_HDRS),
    includes = [
        ".",
    ],
)

cu_library(
    name = "gloo_cuda",
    srcs = GLOO_CUDA_SRCS,
    visibility = ["//visibility:public"],
    deps = [
        ":gloo_headers",
    ],
    alwayslink = True,
)

cc_library(
    name = "gloo",
    srcs = GLOO_SRCS + GLOO_COMMON_SRCS + if_msvc(GLOO_COMMON_SRCS_WIN, GLOO_COMMON_SRCS_LINUX) + GLOO_RENDEZVOUS_SRCS + GLOO_TRANSPORT_SRCS + if_msvc([], GLOO_TCP_SRCS),
    copts = [
        "-std=gnu++11",
        "-std=c++11",
    ],
    visibility = ["//visibility:public"],
    deps = [":gloo_headers"] + if_cuda(
        [":gloo_cuda"],
        [],
    ),
)
