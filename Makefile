
# ---- Command ---- #

.PHONY : gen clean fclean re test

gen:
	tuist install
	tuist generate

clean:
	rm -rf Tuist/Package.resolved
	rm -rf ~/.tuist/Cache
	rm -rf ~/Library/Caches/tuist
	tuist clean

fclean: clean
	find . -name "*.xcworkspace" -exec rm -rf {} +
	find . -name "*.xcodeproj" -exec rm -rf {} +
	find . -name "DerivedData" -exec rm -rf {} +
	find . -name "Derived" -exec rm -rf {} +

re: fclean gen

init: 
	tuist init

start: init gen

# ---- graph ---- #
graph:
	tuist graph --skip-external-dependencies

# ---- test ---- #

test:
	tuist test
