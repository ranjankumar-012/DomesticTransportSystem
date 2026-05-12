package com.transport.dao;

import com.transport.model.User;

public interface UserDAO {
    boolean registerUser(User user);
    User loginUser(String username, String password);
    User getUserById(int id);
    boolean updateUser(User user);
    boolean emailExists(String email);
    boolean usernameExists(String username);
}
