# CPack configuration for Alpine archive
# This file is used as CPACK_PROJECT_CONFIG_FILE

# Configure CPack for creating the archive
set(CPACK_GENERATOR "TGZ")
set(CPACK_PACKAGE_NAME "kamailio-alpine")
set(CPACK_PACKAGE_VERSION "${PROJECT_VERSION}")
set(CPACK_PACKAGING_INSTALL_PREFIX "")

set(CPACK_SOURCE_IGNORE_FILES .git/ build-*/* ".*~$")
set(CPACK_VERBATIM_VARIABLES YES)

function(_get_all_cmake_targets out_var current_dir)
  get_property(
    targets
    DIRECTORY ${current_dir}
    PROPERTY BUILDSYSTEM_TARGETS
  )
  get_property(
    subdirs
    DIRECTORY ${current_dir}
    PROPERTY SUBDIRECTORIES
  )

  foreach(subdir ${subdirs})
    _get_all_cmake_targets(subdir_targets ${subdir})
    list(APPEND targets ${subdir_targets})
  endforeach()

  set(${out_var}
      ${targets}
      PARENT_SCOPE
  )
endfunction()

# Run at end of top-level CMakeLists
_get_all_cmake_targets(all_targets ${CMAKE_SOURCE_DIR})
# message("All CMake targets: ${all_targets}")

# install(RUNTIME_DEPENDENCY_SET kamailio_runtime_deps)

foreach(target ${all_targets})
  get_target_property(target_type ${target} TYPE)
  if(NOT target_type)
    message(STATUS "Target ${target} has no type; skipping")
    continue()
  endif()
  if(NOT target_type STREQUAL "SHARED_LIBRARY")
    message(STATUS "Skipping target ${target} of type ${target_type}")
    continue()
  endif()
  message(STATUS "Processing target for runtime deps: ${target}")
  install(
    CODE [[
        file(GET_RUNTIME_DEPENDENCIES
                LIBRARIES "$<TARGET_FILE:${target}>"
                RESOLVED_DEPENDENCIES_VAR RUNTIME_DEPS
                UNRESOLVED_DEPENDENCIES_VAR UNRESOLVED_DEPS
                DIRECTORIES /lib /usr/lib /usr/local/lib /lib64 /usr/lib64)
        message(WARNING "Resolved dependencies for target ${target}: ${RUNTIME_DEPS}")
        message(WARNING "Unresolved dependencies for target ${target}: ${UNRESOLVED_DEPS}")

        foreach(dep ${RUNTIME_DEPS})
          # Skip if already in install dir
          if(NOT dep MATCHES "^${CMAKE_INSTALL_PREFIX}")
            get_filename_component(dep_name ${dep} NAME)
            file(
              COPY ${dep}
              DESTINATION "${CMAKE_INSTALL_PREFIX}/lib/deps"
              FOLLOW_SYMLINK_CHAIN
            )
          endif()
        endforeach()

        if(UNRESOLVED_DEPS)
          message(WARNING "Unresolved dependencies for target ${target}: ${UNRESOLVED_DEPS}")
        endif()
      ]]
  )
endforeach()

include(CPack)
