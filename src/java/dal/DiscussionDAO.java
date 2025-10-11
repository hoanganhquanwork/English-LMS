/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dal;

import java.sql.*;

import java.util.ArrayList;
import java.util.List;
import model.dto.DiscussionCommentDTO;
import model.dto.DiscussionDTO;
import model.dto.DiscussionPostDTO;
import model.entity.Discussion;

/**
 *
 * @author Admin
 */
public class DiscussionDAO extends DBContext {

    private UserDAO udao = new UserDAO();

    public DiscussionDTO getDiscussionByModuleItemId(int moduleItemId) {
        DiscussionDTO discussionDTO = null;
        String sql = "SELECT * FROM Discussion WHERE discussion_id = ? ";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, moduleItemId);
            ResultSet rs = st.executeQuery();
            if (rs.next()) {
                discussionDTO = new DiscussionDTO();
                discussionDTO.setDiscussionId(rs.getInt("discussion_id"));
                discussionDTO.setTitle(rs.getString("title"));
                discussionDTO.setDescription(rs.getString("description"));
                List<DiscussionPostDTO> posts = getDiscussionPosts(discussionDTO.getDiscussionId());
                discussionDTO.setPosts(posts);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return discussionDTO;
    }

    public List<DiscussionPostDTO> getDiscussionPostsByPage(int discussionId, int pageNumber, int pageSize) {
        List<DiscussionPostDTO> listPost = new ArrayList<>();
        String sql = "SELECT post_id, discussion_id, author_user_id, content, "
                + " CONVERT(date, created_at) AS created_at, "
                + " CONVERT(date, edited_at) AS edited_at"
                + " FROM DiscussionPosts WHERE discussion_id = ? "
                + " ORDER BY created_at "
                + " OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";

        try {
            PreparedStatement st = connection.prepareStatement(sql);
            int offset = (pageNumber - 1) * pageSize;
            st.setInt(1, discussionId);
            st.setInt(2, offset);
            st.setInt(3, pageSize);

            ResultSet rs = st.executeQuery();

            while (rs.next()) {
                DiscussionPostDTO post = new DiscussionPostDTO();
                post.setPostId(rs.getLong("post_id"));
                post.setContent(rs.getString("content"));
                post.setRole(udao.getUserById(rs.getInt("author_user_id")).getRole());
                post.setAuthorName(udao.getUserById(rs.getInt("author_user_id")).getUsername());
                post.setAvatar(udao.getUserById(rs.getInt("author_user_id")).getProfilePicture());
                post.setFullName(udao.getUserById(rs.getInt("author_user_id")).getFullName());
                post.setCreatedAt(rs.getString("created_at"));
                post.setEditedAt(rs.getString("edited_at"));

                List<DiscussionCommentDTO> comments = getDiscussionComments(post.getPostId());
                post.setComments(comments);

                listPost.add(post);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return listPost;
    }

    public int getTotalPostCount(int discussionId) {
        String sql = "SELECT COUNT(*) FROM DiscussionPosts WHERE discussion_id = ?";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, discussionId);
            ResultSet rs = st.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    public List<DiscussionPostDTO> getDiscussionPosts(int discussionId) {
        List<DiscussionPostDTO> listPost = new ArrayList<>();
        String sql = "SELECT * FROM DiscussionPosts WHERE discussion_id = ?";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, discussionId);
            ResultSet rs = st.executeQuery();
            while (rs.next()) {
                DiscussionPostDTO post = new DiscussionPostDTO();
                post.setPostId(rs.getLong("post_id"));
                post.setContent(rs.getString("content"));
                post.setRole(udao.getUserById(rs.getInt("author_user_id")).getRole());
                post.setAuthorName(udao.getUserById(rs.getInt("author_user_id")).getUsername());
                post.setAvatar(udao.getUserById(rs.getInt("author_user_id")).getProfilePicture());
                post.setFullName(udao.getUserById(rs.getInt("author_user_id")).getFullName());
                post.setCreatedAt(rs.getString("created_at"));
                post.setEditedAt(rs.getString("edited_at"));
                List<DiscussionCommentDTO> comments = getDiscussionComments(post.getPostId());
                post.setComments(comments);
                listPost.add(post);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return listPost;

    }

    private List<DiscussionCommentDTO> getDiscussionComments(long postId) {
        List<DiscussionCommentDTO> listComment = new ArrayList<>();
        String sql = "SELECT comment_id, post_id, author_user_id, content, "
                + " CONVERT(date, created_at) AS created_at,  "
                + " CONVERT(date, edited_at) AS edited_at   "
                + " FROM DiscussionComments WHERE post_id = ?";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setLong(1, postId);
            ResultSet rs = st.executeQuery();
            while (rs.next()) {
                DiscussionCommentDTO comment = new DiscussionCommentDTO();
                comment.setCommentId(rs.getLong("comment_id"));
                comment.setPostId(rs.getLong("post_id"));
                comment.setContent(rs.getString("content"));
                comment.setRole(udao.getUserById(rs.getInt("author_user_id")).getRole());
                comment.setAvatar(udao.getUserById(rs.getInt("author_user_id")).getProfilePicture());
                comment.setFullName(udao.getUserById(rs.getInt("author_user_id")).getFullName());
                comment.setAuthorName(udao.getUserById(rs.getInt("author_user_id")).getUsername());
                comment.setCreatedAt(rs.getString("created_at"));
                comment.setEditedAt(rs.getString("edited_at"));
                listComment.add(comment);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return listComment;
    }

    public boolean addDiscussionPost(String content, int authorUserId, int discussionId) {
        String sql = "INSERT INTO DiscussionPosts (content, author_user_id, discussion_id) VALUES (?, ?, ?)";

        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setString(1, content);
            st.setInt(2, authorUserId);
            st.setInt(3, discussionId);

            int rowsAffected = st.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean addDiscussionComment(long postId, String content, int authorUserId) {
        String sql = "INSERT INTO DiscussionComments (post_id, content, author_user_id) VALUES (?, ?, ?)";

        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setLong(1, postId);
            st.setString(2, content);
            st.setInt(3, authorUserId);

            int rowsAffected = st.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean updateDiscussionPost(long postId, String content) {
        String sql = "UPDATE DiscussionPosts SET content = ?, edited_at = CURRENT_TIMESTAMP WHERE post_id = ?";

        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setString(1, content);
            st.setLong(2, postId);
            int rowsAffected = st.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean updateDiscussionComment(long commentId, String content) {
        String sql = "UPDATE DiscussionComments SET content = ?, edited_at = CURRENT_TIMESTAMP WHERE comment_id = ?";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setString(1, content);
            st.setLong(2, commentId);

            int rowsAffected = st.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean hasDiscussionPost(int authorUserId, int discussionId) {
        String sql = "SELECT 1 FROM DiscussionPosts WHERE author_user_id = ? AND discussion_id = ?";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, authorUserId);
            st.setInt(2, discussionId);
            ResultSet rs = st.executeQuery();
            return rs.next();
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public DiscussionPostDTO getDiscussionPostsById(int discussionId, int userId) {
        String sql = "SELECT * FROM DiscussionPosts WHERE discussion_id = ? AND author_user_id = ? ";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, discussionId);
            st.setInt(2, userId);

            ResultSet rs = st.executeQuery();
            if (rs.next()) {
                DiscussionPostDTO post = new DiscussionPostDTO();
                post.setPostId(rs.getLong("post_id"));
                post.setContent(rs.getString("content"));
                post.setRole(udao.getUserById(rs.getInt("author_user_id")).getRole());
                post.setAuthorName(udao.getUserById(rs.getInt("author_user_id")).getUsername());
                post.setAvatar(udao.getUserById(rs.getInt("author_user_id")).getProfilePicture());
                post.setFullName(udao.getUserById(rs.getInt("author_user_id")).getFullName());
                post.setCreatedAt(rs.getString("created_at"));
                post.setEditedAt(rs.getString("edited_at"));
                List<DiscussionCommentDTO> comments = getDiscussionComments(post.getPostId());
                post.setComments(comments);
                return post;
            }
        } catch (SQLException e) {
            e.printStackTrace();

        }
        return null;
    }

    //for view my discussion
    public DiscussionPostDTO getDiscussionPostsByUserId(int discussionId, int userId) {
        String sql = "SELECT * FROM DiscussionPosts WHERE discussion_id = ? AND author_user_id = ?";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, discussionId);
            st.setInt(2, userId);  

            ResultSet rs = st.executeQuery();
            if (rs.next()) {
                DiscussionPostDTO post = new DiscussionPostDTO();
                post.setPostId(rs.getLong("post_id"));
                post.setContent(rs.getString("content"));
                post.setRole(udao.getUserById(rs.getInt("author_user_id")).getRole());
                post.setAuthorName(udao.getUserById(rs.getInt("author_user_id")).getUsername());
                post.setAvatar(udao.getUserById(rs.getInt("author_user_id")).getProfilePicture());
                post.setFullName(udao.getUserById(rs.getInt("author_user_id")).getFullName());
                post.setCreatedAt(rs.getString("created_at"));
                post.setEditedAt(rs.getString("edited_at"));
                List<DiscussionCommentDTO> comments = getDiscussionComments(post.getPostId());
                post.setComments(comments);
                return post;  
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

}
