
cmake_minimum_required(VERSION 3.10)

add_executable(hello
	main.c	
)

install(TARGETS hello RUNTIME DESTINATION bin)

