module top_module(
    input clk,
    input reset,    // Synchronous reset
    input in,
    output disc,
    output flag,
    output err);
    parameter first =0,second =1,third=2,fourth =3,fifth=4,sixth = 5,hdlc=6,discc=7,hdlc_detect=8,detect_error=10;
    reg [3:0] state,next_state;
    reg [2:0] counter ;
    always@(posedge clk) begin
        if(reset)
            state <= first;
        else
            state <= next_state;
    end
    
   
    
    always@(*) begin
        case(state)
            first:
                begin
                if(in)
                    next_state = second;
            	else
                    next_state = state;
                end
            second:
                 begin
                if(in)
                    next_state = third;
            	else
                    next_state = first;
                end
            third:
                 begin
                if(in)
                    next_state = fourth;
            	else
                    next_state = first;
                end
            fourth:
                 begin
                if(in)
                    next_state = fifth;
            	else
                    next_state = first;
                end
            fifth:
                begin
                if(in)
                    next_state = sixth;
            	else
                    next_state = first;
                end
            sixth:
                begin
                if(in)
                    next_state = hdlc;
            	else
                    next_state = discc;
                end
            hdlc:
                begin
                if(in)
                    next_state = detect_error;
            	else
                    next_state = hdlc_detect;
                end
            hdlc_detect:
                begin
                    if(in)
                        next_state = second;
                    else
                        next_state = first;
                end
            discc:
                begin
                    if(in)
                        next_state = second;
                    else
                        next_state = first;  
                end
            detect_error:
                begin
                    if(in)
                        next_state = detect_error;
                    else
                        next_state = first;
                end
            
        endcase
    end
    
    assign disc = (state == discc) ? 1:0;
    assign flag = (state == hdlc_detect)? 1:0;
    assign err = (state == detect_error)? 1:0;
                
                
            
                
                
            
            

endmodule
