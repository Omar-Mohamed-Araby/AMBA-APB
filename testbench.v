module tb_Top;

    parameter ADDR_WIDTH = 32;
    parameter DATA_WIDTH = 32;
    parameter STROBE_WIDTH = DATA_WIDTH / 8;
    parameter PROT_WIDTH = 3;

    reg PCLK;
    reg PRESETn;
    reg [PROT_WIDTH-1:0] MPROT;
    reg [ADDR_WIDTH-1:0] MADDR;
    reg MWRITE;
    reg MREQ;
    reg [DATA_WIDTH-1:0] MWDATA;
    reg [STROBE_WIDTH-1:0] MSTRB;

    wire MSLVERR;
    wire [DATA_WIDTH-1:0] MRDATA;
    wire MREADY;

    Top dut (PCLK,PRESETn,MADDR,MWDATA,MSTRB,MWRITE,MREQ,MPROT,MSLVERR,MRDATA,MREADY);

    // Clock generation
    initial begin
        PCLK = 0;
        forever begin
        #5  PCLK = ~PCLK;
        end
    end

    initial begin
        MPROT   = 3'b000;
        MADDR   = 32'b0;
        MWDATA  = 32'b0;
        MWRITE  = 0;
        MREQ    = 0;
        MSTRB   = 4'b1111;
        PRESETn = 0;
        repeat(2) @(negedge PCLK);
        PRESETn = 1;
        @(negedge PCLK);

        // -----------------------------
        // Write to slave1 (PSEL0)
        // MADDR = last word
        // -----------------------------
        MADDR  = 32'h0000_001F;
        MWDATA = 32'h00000055;
        MWRITE = 1;
        MSTRB  = 4'b1111;
        MREQ   = 1;
        @(posedge MREADY);

        // -----------------------------
        // Immediate write to slave2 (PSEL1)
        // MADDR = last word
        // MSTRB = 0001
        // -----------------------------
        MADDR  = 32'h0000_003F;
        MWDATA = 32'h88000055;
        MSTRB  = 4'b1000;
        // Keep MREQ high
        @(posedge MREADY);

        // -----------------------------
        // Deassert MREQ for 2 cycles
        // -----------------------------
        MREQ = 0;
        repeat(3) @(negedge PCLK);

        // -----------------------------
        // Read from slave1
        // -----------------------------
        MADDR  = 32'h0000_001F;
        MWRITE = 0;
        MSTRB  = 4'b0000;
        MREQ   = 1;
        @(posedge MREADY);

        // Latch read data
        @(negedge PCLK);

        // End test
        MREQ = 0;
        repeat(3) @(negedge PCLK);
        $stop;
    end

endmodule
