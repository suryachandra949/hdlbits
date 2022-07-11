module top_module(
    input clk,
    input in,
    input reset,    // Synchronous reset
    output [7:0] out_byte,
    output done
); //

    // Use FSM from Fsm_serial
     parameter idle =0, rec_data = 1, stop=2,nxt_data = 3,error=4;
    reg [2:0] state,next_state;
    reg [3:0] counter;


    always@(posedge clk) begin
        if(reset)
            state <= idle;
        else
            state <= next_state;
    end

    always@(posedge clk) begin
        if(state == rec_data)
            counter <= counter + 1;
        else
            counter <=0;
    end

    always@(*) begin

        case(state)
            idle:
                begin
                if(~in)
                    next_state = rec_data;
            	else
                    next_state = state;
                end
            rec_data:
                begin

                    if(counter ==7)
                        next_state = stop;
                    else
                        next_state = rec_data;
                end
            stop:
                begin
                if(in)
                   next_state = nxt_data;
                else
                    next_state = error;
                end
            error:
                begin
                    if(in)
                        next_state = idle;
                    else
                        next_state = state;
                end

            nxt_data:
                begin
                    if(~in)
                        next_state = rec_data;
                    else
                        next_state = idle;
                end
        endcase
    end

    assign done = (state == nxt_data)? 1:0;

    // New: Datapath to latch input bits.

    always@(posedge clk) begin
        if(state == rec_data)
            out_byte[7:0] = {in,out_byte[7:1]};
    end


endmodule
