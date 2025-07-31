module APB_BUS (PCLK,PRESETn,PADDR,PPROT,PSEL0,PSEL1,PENABLE,PWRITE,PWDATA,PSTRB,PREADY,PRDATA,PSLVERR,
MADDR,MWDATA,MSTRB,MWRITE,MREQ,MPROT,MSLVERR,MRDATA,MREADY);

    parameter ADDR_WIDTH = 32;
    parameter DATA_WIDTH = 32;
    parameter STROBE_WIDTH = DATA_WIDTH/8;
    parameter PROT_WIDTH = 3;
    parameter IDLE = 0;
    parameter SETUP = 1;
    parameter ACCESS = 2;
    

    input PCLK,PRESETn;
    input PREADY;
    input [PROT_WIDTH-1:0] MPROT;
    input [DATA_WIDTH-1:0] PRDATA;
    input PSLVERR;
    input [ADDR_WIDTH-1:0] MADDR;
    input MWRITE;
    input MREQ;
    input [DATA_WIDTH-1:0] MWDATA;
    input [STROBE_WIDTH-1:0] MSTRB;

    output reg [ADDR_WIDTH-1:0] PADDR;
    output reg PSEL0,PSEL1;
    output reg [PROT_WIDTH-1:0] PPROT;
    output reg PWRITE;
    output reg [DATA_WIDTH-1:0] PWDATA;
    output reg [STROBE_WIDTH-1:0] PSTRB;
    output reg PENABLE;
    output reg MSLVERR;
    output reg [DATA_WIDTH-1:0] MRDATA;
    output  MREADY;

    
    reg [1:0] current_state,next_state;

    assign MREADY = PREADY;

    always @(posedge PCLK) begin
        if(!PRESETn)
            current_state <= IDLE;
        else
            current_state <= next_state;
    end

    always @(*) begin
        case (current_state)
            IDLE:begin 
                PENABLE = 0;
                PSEL0 = 0;
                PSEL1 = 0;
                PADDR = 0;
                PWRITE = 0;
                PWDATA = 0;
                PSTRB = 0;
                PPROT = 0;
                if (MREQ)
                    next_state = SETUP;
                else 
                    next_state = IDLE;
            end
            SETUP:begin
                PENABLE = 0;
                PADDR = MADDR;
                PWRITE = MWRITE;
                PWDATA = MWDATA;
                PSTRB = MSTRB;
                PPROT = MPROT;
                if (MADDR >= 32'h0000_0000 && MADDR <= 32'h0000_001F) begin
                PSEL0 = 1'b1;
                PSEL1 = 1'b0;
                end else if (MADDR >= 32'h0000_0020 && MADDR <= 32'h0000_003F) begin
                PSEL0 = 1'b0;
                PSEL1 = 1'b1;
                end else begin
                PSEL0 = 1'b0;
                PSEL1 = 1'b0;
                end
                next_state = ACCESS;
            end
            ACCESS:begin
                PENABLE = 1;
                if (PREADY) begin
                    if (MREQ) 
                        next_state = SETUP;
                    else
                        next_state = IDLE;

                    MSLVERR = PSLVERR;
                end
                else 
                    next_state = ACCESS;
            end
            default: begin
                PENABLE = 0;
                PADDR = 0;
                PWRITE = 0;
                PWDATA = 0;
                PSTRB = 0;
                PPROT = 0;
                PSEL0 = 0;
                PSEL1 = 0;
                next_state = IDLE;
            end
        endcase
    end

   always @(posedge PCLK) begin
        if(!PRESETn)
                MRDATA <= 0;
        else begin
                MRDATA <= PRDATA;
        end
    end

endmodule