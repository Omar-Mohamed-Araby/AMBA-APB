module SLAVE_WRAPPER (PCLK,PRESETn,PADDR,PPROT,PSEL0,PENABLE,PWRITE,PWDATA,PSTRB,PREADY,PRDATA,PSLVERR,LPSEL);

    parameter ADDR_WIDTH = 32;
    parameter DATA_WIDTH = 32;
    parameter STROBE_WIDTH = DATA_WIDTH/8;
    parameter PROT_WIDTH = 3;
    parameter MEM_DEPTH = 32;
    
    input PCLK,PRESETn;
    input PSEL0;
    input PENABLE;
    input PWRITE;
    input [PROT_WIDTH-1:0] PPROT;
    input [ADDR_WIDTH-1:0] PADDR;
    input [DATA_WIDTH-1:0] PWDATA;
    input [STROBE_WIDTH-1:0] PSTRB;

    output PREADY;
    output PSLVERR;
    output [DATA_WIDTH-1:0] PRDATA;
    output reg LPSEL;

    MEM mem_inst (PCLK, PRESETn, PADDR, (PSEL0 && PENABLE), 
    PWRITE, (PWDATA & {{8{PSTRB[3]}},{8{PSTRB[2]}},{8{PSTRB[1]}},{8{PSTRB[0]}}}), PRDATA, PREADY);

    assign PSLVERR = 0; 


    always @(posedge PCLK) begin
        if (!PRESETn) begin
            LPSEL <= 0;
        end
        else if (PSEL0 && PENABLE) begin
            if (PWRITE) begin
                LPSEL <= 0; // No need to set LPSEL on write
            end
            else begin
                LPSEL <= PSEL0; // Set LPSEL on read
            end
        end
    end

endmodule