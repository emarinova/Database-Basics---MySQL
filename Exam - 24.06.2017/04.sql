DELETE u FROM users AS u
LEFT JOIN users_contests AS u_c ON u.id = u_c.user_id
WHERE u_c.user_id IS NULL;

