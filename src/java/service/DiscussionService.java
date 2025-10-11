/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package service;

import dal.DiscussionDAO;
import java.util.List;
import model.dto.DiscussionDTO;
import model.dto.DiscussionPostDTO;

/**
 *
 * @author Admin
 */
public class DiscussionService {

    private DiscussionDAO discussionDAO = new DiscussionDAO();

    public boolean addDiscussionPost(String content, int authorUserId, int discussionId) {
        if (content == null || content.trim().isEmpty()) {
            throw new IllegalArgumentException("Nội dung bài thảo luận không được để trống.");
        }

        return discussionDAO.addDiscussionPost(content, authorUserId, discussionId);
    }

    public boolean addDiscussionComment(long postId, String content, int authorUserId) {
        if (content == null || content.trim().isEmpty()) {
            throw new IllegalArgumentException("Nội dung bình luận không được để trống.");
        }

        return discussionDAO.addDiscussionComment(postId, content, authorUserId);
    }

    public boolean updateDiscussionPost(long postId, String content) {
        if (content == null || content.trim().isEmpty()) {
            throw new IllegalArgumentException("Nội dung bài thảo luận không được để trống.");
        }
        return discussionDAO.updateDiscussionPost(postId, content);
    }

    public boolean updateDiscussionComment(long commentId, String content) {
        if (content == null || content.trim().isEmpty()) {
            throw new IllegalArgumentException("Nội dung bình luận không được để trống.");
        }

        return discussionDAO.updateDiscussionComment(commentId, content);
    }

    public DiscussionDTO getDiscussionByModuleItemId(int moduleItemId) {
        return discussionDAO.getDiscussionByModuleItemId(moduleItemId);
    }

    public List<DiscussionPostDTO> getListDiscussionPost(int discussionId, int pageNumber, int pageSize) {
        return discussionDAO.getDiscussionPostsByPage(discussionId, pageNumber, pageSize);
    }

    public int countDiscusionPost(int discussionId) {
        return discussionDAO.getTotalPostCount(discussionId);
    }

    public boolean hasDiscussionPost(int authorUserId, int discussionId) {
        if (authorUserId < 0 || discussionId < 0) {
            throw new IllegalArgumentException("Không thể kiểm tra trạng thái bài thảo luận");
        }
        return discussionDAO.hasDiscussionPost(authorUserId, discussionId);
    }

    public DiscussionPostDTO getPostOfUserInDiscussion(int discussionId, int authorUserId) {
        if (authorUserId < 0 || discussionId < 0) {
            throw new IllegalArgumentException("Không tìm thấy bài thảo luận");
        }
        return discussionDAO.getDiscussionPostsByUserId(discussionId, authorUserId);
    }

    public int getPageNumberForPost(int discussionId, int authorUserId, int pageSize) {
        List<DiscussionPostDTO> posts = discussionDAO.getDiscussionPosts(discussionId);
        int postIndex = -1;
        long postUserId = getPostOfUserInDiscussion(discussionId, authorUserId).getPostId();
        for (int i = 0; i < posts.size(); i++) {
            if (posts.get(i).getPostId() == postUserId) {
                postIndex = i;
                break;
            }
        }
        if (postIndex == -1) {
            return 1; // If discussion not found set page number = 1
        }
        return (postIndex / pageSize) + 1;
    }
}
