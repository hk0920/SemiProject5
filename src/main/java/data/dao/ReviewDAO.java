package data.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.List;
import java.util.Vector;

import data.dto.ReviewDTO;
import mysql.db.DBConnect;

public class ReviewDAO {
	DBConnect db=new DBConnect();
	public void insertReview(ReviewDTO dto)
	{
		Connection conn=db.getConnection();
		PreparedStatement pstmt=null;
		String sql="insert into review (nickname,photo,content,write_day) values (?,?,?,now())";
		
		try {
			pstmt=conn.prepareStatement(sql);
			//諛붿씤�뵫
			pstmt.setString(1, dto.getNickname());
			pstmt.setString(2, dto.getPhoto());
			pstmt.setString(3, dto.getContent());
			
			pstmt.execute();
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}finally {
			db.dbClose(pstmt, conn);
		}
	}
	public int getTotalCount()
	{
		int n=0;
		Connection conn=db.getConnection();
		PreparedStatement pstmt=null;
		ResultSet rs=null;
		String sql="select count(*) from review";

		try {
			pstmt=conn.prepareStatement(sql);
			rs=pstmt.executeQuery();
			if(rs.next())
				n=rs.getInt(1);

		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}finally {
			db.dbClose(rs,pstmt, conn);
		}
		return n;
	}
	public List<ReviewDTO> getList(int start,int perpage)
	{
		List<ReviewDTO> list=new Vector<ReviewDTO>();
		Connection conn=db.getConnection();
		PreparedStatement pstmt=null;
		ResultSet rs=null;
		String sql="select * from review order by idx desc limit ?,?";
		try {
			pstmt=conn.prepareStatement(sql);
			//獄쏅뗄�뵥占쎈뎃
			pstmt.setInt(1, start);
			pstmt.setInt(2, perpage);
			rs=pstmt.executeQuery();
			while(rs.next())
			{
				ReviewDTO dto=new ReviewDTO();
				dto.setIdx(rs.getString("idx"));
				dto.setNickname(rs.getString("nickname"));
				dto.setPhoto(rs.getString("photo"));
				dto.setContent(rs.getString("content"));
				dto.setWrite_day(rs.getTimestamp("write_day"));
				list.add(dto);

			}
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}finally {
			db.dbClose(rs, pstmt, conn);
		}
		return list;
	}
}
