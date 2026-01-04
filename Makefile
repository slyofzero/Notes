# -------- Configuration --------
SRC_DIR := ../../GATE\ Notes/
DEST_DIR := ./content/

# space-separated folder names (relative to SRC_DIR)
EXCLUDE_DIRS := .obsidian Drawings Templates

# -------- Targets --------
.PHONY: copy_dirs clean

copy_dirs:
	find $(SRC_DIR) -mindepth 1 -maxdepth 1 -exec cp -r {} $(DEST_DIR) \;
	@for dir in $(EXCLUDE_DIRS); do rm -rf $(DEST_DIR)$$dir; done

clean:
	rm -rf $(DEST_DIR)
	mkdir $(DEST_DIR)