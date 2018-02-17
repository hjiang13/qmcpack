# Check compiler version
IF ( CMAKE_CXX_COMPILER_VERSION VERSION_LESS 3.3 )
  MESSAGE(STATUS "Compiler Version ${CMAKE_CXX_COMPILER_VERSION}")
  MESSAGE(FATAL_ERROR "Requires clang 3.3 or higher ")
ENDIF()

# Set the std
SET(CMAKE_C_FLAGS     "${CMAKE_C_FLAGS} -std=c99")

# Enable OpenMP
SET(ENABLE_OPENMP 1)
IF ( ENABLE_OPENMP )
    SET(CMAKE_C_FLAGS     "${CMAKE_C_FLAGS} -fopenmp")
    SET(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -fopenmp")
    SET(CMAKE_C_FLAGS_RELEASE     "${CMAKE_C_FLAGS_RELEASE} -fopenmp")
    SET(CMAKE_CXX_FLAGS_RELEASE "${CMAKE_CXX_FLAGS_RELEASE} -fopenmp")
    SET(CMAKE_C_FLAGS_RELEASE     "${CMAKE_C_FLAGS_RELWITHDEBINFO} -fopenmp")
    SET(CMAKE_CXX_FLAGS_RELEASE "${CMAKE_CXX_FLAGS_RELWITHDEBINFO} -fopenmp")
ENDIF()

# Set clang specfic flags (which we always want)
ADD_DEFINITIONS( -Drestrict=__restrict__ )

SET(CMAKE_C_FLAGS     "${CMAKE_C_FLAGS} -fomit-frame-pointer -fstrict-aliasing -D__forceinline=inline")
SET(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -fomit-frame-pointer -fstrict-aliasing -D__forceinline=inline")

IF (CMAKE_CXX_COMPILER_VERSION VERSION_GREATER 5.0 )
  SET( HAVE_POSIX_MEMALIGN 1 )    # Clang doesn't support -malign-double it does in 5.0.1
ELSE ()
  SET( HAVE_POSIX_MEMALIGN 0 )
ENDIF()

# Suppress compile warnings
SET(CMAKE_C_FLAGS     "${CMAKE_C_FLAGS} -Wno-deprecated -Wno-unused-value")
SET(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Wno-deprecated -Wno-unused-value -Wno-undefined-var-template")
SET(CMAKE_C_FLAGS_RELEASE     "${CMAKE_C_FLAGS_RELEASE} -Wno-deprecated -Wno-unused-value")
SET(CMAKE_CXX_FLAGS_RELEASE "${CMAKE_CXX_FLAGS_RELEASE} -Wno-deprecated -Wno-unused-value -Wno-undefined-var-template")
SET( CMAKE_C_FLAGS_RELWITHDEBINFO     "${CMAKE_C_FLAGS_RELWITHDEBINFO} -Wno-deprecated -Wno-unused-value" )
SET( CMAKE_CXX_FLAGS_RELWITHDEBINFO "${CMAKE_CXX_FLAGS_RELWITHDEBINFO} -Wno-deprecated -Wno-unused-value -Wno-undefined-var-template" )

# Set extra optimization specific flags
SET( CMAKE_C_FLAGS_RELEASE     "${CMAKE_C_FLAGS_RELEASE} -ffast-math -D__forceinline=inline" )
SET( CMAKE_CXX_FLAGS_RELEASE "${CMAKE_CXX_FLAGS_RELEASE} -ffast-math -D__forceinline=inline" )
SET( CMAKE_C_FLAGS_RELWITHDEBINFO     "${CMAKE_C_FLAGS_RELWITHDEBINFO} -ffast-math -D__forceinline=inline" )
SET( CMAKE_CXX_FLAGS_RELWITHDEBINFO "${CMAKE_CXX_FLAGS_RELWITHDEBINFO} -ffast-math -D__forceinline=inline" )

MESSAGE ( "LLVM LLD: ${ENABLE_LLVM_LLD}"  )
IF (ENABLE_LLVM_LLD)
  SET ( CMAKE_EXE_LINKER_FLAGS ${CMAKE_EXE_LINKER_FLAGS} -fuse-ld=lld )
  SET ( CMAKE_EXE_LINKER_FLAGS_RELEASE ${CMAKE_EXE_LINKER_FLAGS_RELEASE} -fuse-ld=lld )
  SET ( CMAKE_EXE_LINKER_FLAGS_RELWITHDEBINFO ${CMAKE_EXE_LINKER_FLAGS_RELWITHDEBINFO} -fuse-ld=lld )
ENDIF()

#------------------------
# Not on Cray's machine
#------------------------
IF(NOT $ENV{CRAYPE_VERSION} MATCHES ".")

#check if the user has already specified -march=XXXX option for cross-compiling.
if(CMAKE_CXX_FLAGS MATCHES "-march=" OR CMAKE_C_FLAGS MATCHES "-march=")
  # make sure that the user specifies -march= for both CMAKE_CXX_FLAGS and CMAKE_C_FLAGS.
  if(CMAKE_CXX_FLAGS MATCHES "-march=" AND CMAKE_C_FLAGS MATCHES "-march=")
  else() #(CMAKE_CXX_FLAGS MATCHES "-march=" AND CMAKE_C_FLAGS MATCHES "-march=")
    MESSAGE(FATAL_ERROR "if -march=ARCH is specified by the user, it should be added in both CMAKE_CXX_FLAGS and CMAKE_C_FLAGS!")
  endif() #(CMAKE_CXX_FLAGS MATCHES "-march=" AND CMAKE_C_FLAGS MATCHES "-march=")
else() #(CMAKE_CXX_FLAGS MATCHES "-march=" OR CMAKE_C_FLAGS MATCHES "-march=")
  # use -march=native
  SET(CMAKE_C_FLAGS     "${CMAKE_C_FLAGS} -march=native")
  SET(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -march=native")
endif() #(CMAKE_CXX_FLAGS MATCHES "-march=" OR CMAKE_C_FLAGS MATCHES "-march=")

ENDIF(NOT $ENV{CRAYPE_VERSION} MATCHES ".")

# Add static flags if necessary
IF(QMC_BUILD_STATIC)
    SET(CMAKE_CXX_LINK_FLAGS " -static")
ENDIF(QMC_BUILD_STATIC)

# Coverage
IF (ENABLE_GCOV)
  SET(GCOV_COVERAGE TRUE)
  SET(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} --coverage")
  SET(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} --coverage")
  SET(CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} --coverage")
  SET(CMAKE_SHARED_LINKER_FLAGS "${CMAKE_SHARED_LINKER_FLAGS} --coverage")
ENDIF(ENABLE_GCOV)

