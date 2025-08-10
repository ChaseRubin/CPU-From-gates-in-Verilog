# === CONFIG ===
TOP_MODULE = ir_tb
OUTPUT = ir.out
VCD = wave.vcd
FILELIST = files.f

# === DEFAULT TARGET ===
all: run

# === COMPILE ===
$(OUTPUT): $(FILELIST)
	iverilog -f $(FILELIST) -s $(TOP_MODULE) -o $(OUTPUT)

# === RUN SIMULATION ===
run: $(OUTPUT)
	vvp $(OUTPUT)

# === VIEW WAVEFORM ===
wave: run
	gtkwave $(VCD)

# === CLEAN UP ===
clean:
	rm -f $(OUTPUT) $(VCD)
