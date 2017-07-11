`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:25:15 03/24/2017 
// Design Name: 
// Module Name:    collisiondetect 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module CollisionDetect(
    input clk,
    input reset,
    input in_val,
    input [7:0] x1,
    input [7:0] y1,
    input [7:0] z1,
    input [7:0] x2,
    input [7:0] y2,
    input [7:0] z2,
    output reg out_val,
    output reg [7:0] lineID
    );
	 
	 reg [0:7] a [0:60][0:6];
	integer i=0;
	integer j=0;
	integer row=0;
	integer o1,o2,o3,o4;
	reg result;
	
	function integer orientation;
	input p1,p2,q1,q2,r1,r2;
	integer p1,p2,q1,q2,r1,r2;
	begin
	orientation=(q2-p2)*(r1-q1)-(q1-p1)*(r2-q2);
	if(orientation==0)
	orientation=0;
	else if(orientation>0)
	orientation=1;
	else if(orientation<0)
	orientation=2;
	end
	endfunction
	
	function integer max;
	input x,y;
	integer x,y;
	begin
	if(x>=y)
		max=x;
	else
		max=y;
	end
	endfunction
	
	function integer min;
	input x,y;
	integer x,y;
	begin
	if(x<=y)
		min=x;
	else
		min=y;
	end
	endfunction
	
	function integer onSegment;
	input p1,p2,q1,q2,r1,r2;
	integer p1,p2,q1,q2,r1,r2;
	begin
	if(q1<=max(p1,r1) && q1>=min(p1,r1) && q2<=max(p2,r2) && q2>=min(p2,r2))
		onSegment=1;
	else
		onSegment=0;
	end
	endfunction
	
	always @(posedge clk)
	begin
	out_val=1'b0;
   if (in_val == 1'b1) begin
	
	a[row][0]=x1;
	a[row][1]=y1;
	a[row][2]=z1;
	a[row][3]=x2;
	a[row][4]=y2;
	a[row][5]=z2;
	a[row][6]=1'b0;				//invalid bit indicator
	
	
	//if(row>1 && ) //check if z coordinates are same
	//begin
	
	for(i=1;i<=row; i=i+1)
	begin
	if(z1 == a[i-1][2] && a[i-1][6]==1'b0)
	begin
	//$display("i-1:",i-1,"row:",row);
	o1=orientation(a[i-1][0],a[i-1][1],a[i-1][3],a[i-1][4],a[row][0],a[row][1]);
	o2=orientation(a[i-1][0],a[i-1][1],a[i-1][3],a[i-1][4],a[row][3],a[row][4]);
	o3=orientation(a[row][0],a[row][1],a[row][3],a[row][4],a[i-1][0],a[i-1][1]);
	o4=orientation(a[row][0],a[row][1],a[row][3],a[row][4],a[i-1][3],a[i-1][4]);
	
	
	
	if(o1==0 && onSegment(a[i-1][0],a[i-1][1],a[row][0],a[row][1],a[i-1][3],a[i-1][4])==1)
		result=1'b1;
	else if(o2==0 && onSegment(a[i-1][0],a[i-1][1],a[row][3],a[row][4],a[i-1][3],a[i-1][4])==1)
		result=1'b1;
	else if(o3==0 && onSegment(a[row][0],a[row][1],a[i-1][0],a[i-1][1],a[row][3],a[row][4])==1)
		result=1'b1;
	else if(o4==0 && onSegment(a[row][0],a[row][1],a[i-1][3],a[i-1][4],a[row][3],a[row][4])==1)
		result=1'b1;
	else
		result=1'b0;
		
	if(o1 != o2 && o3 != o4) begin
	result=1'b1;
	end
	
	if(result) begin
		out_val=1'b1;
		a[row][6]=1'b1;
		lineID=row+1;
		//$display(x1," ",y1," ",z1," Row:",row," LineID ",lineID);
		
	end
	end
	end
	//$display(out_val,"out_val");
	//$display(a[row-0][0]," ",a[row-1][0]);
	
	row=row+1;
	end
	end
	
	
endmodule
