module MEM #(
    parameter ADDR_WIDTH = 32,
    parameter DATA_WIDTH = 32,
    parameter MEM_DEPTH  = 64
)(
    input                      clk,
    input                      reset_n,
    input  [ADDR_WIDTH-1:0]    address,
    input                      en,
    input                      wr_rd,         // 1 = write, 0 = read
    input  [DATA_WIDTH-1:0]    write_data,
    output reg [DATA_WIDTH-1:0] read_data,
    output                     data_ready
);

    // Declare memory
    reg [DATA_WIDTH-1:0] mem_array [0:MEM_DEPTH-1];

    // Internal ready signal
    reg rdy;

    // Output signal assignment
    assign data_ready = en ? (wr_rd ? en : rdy) : 1'b0;

    always @(posedge clk) begin
        if (!reset_n) begin
            read_data <= {DATA_WIDTH{1'b0}};
            rdy <= 1'b0;
        end else if (en) begin
            if (wr_rd) begin
                mem_array[address] <= write_data; // Write operation
                rdy <= 1'b0;
            end else begin
                read_data <= mem_array[address];  // Read operation
                rdy <= 1'b1;
            end
        end else begin
            rdy <= 1'b0;
        end
    end

endmodule
