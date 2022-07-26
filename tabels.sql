/*  */
create table submaline.accounts
(
    user_id varchar(128) not null
        primary key,
    email   varchar(320) not null,
    constraint accounts_email_uindex
        unique (email)
);

/*  */
create table submaline.user_names
(
    user_id   varchar(128) not null,
    user_name varchar(20)  not null,
    constraint user_names_user_name_uindex
        unique (user_name)
);

/*  */
create table submaline.profiles
(
    user_id        varchar(128)                              null,
    display_name   varchar(30)                  default ''   not null,
    icon_path      varchar(50)                  default ''   not null,
    status_message varchar(50)                  default ''   not null,
    metadata       longtext collate utf8mb4_bin default '{}' not null,
    constraint profiles_accounts_user_id_fk
        foreign key (user_id) references submaline.accounts (user_id)
            on delete cascade,
    constraint metadata
        check (json_valid(`metadata`))
);

/*  */
create table submaline.settings
(
    user_id varchar(128)                              not null,
    setting longtext collate utf8mb4_bin default '{}' not null,
    constraint settings_accounts_user_id_fk
        foreign key (user_id) references submaline.accounts (user_id)
            on delete cascade,
    constraint setting
        check (json_valid(`setting`))
);

create table submaline.friends
(
    id             int auto_increment
        primary key,
    user_id        varchar(128) not null,
    friend_user_id varchar(128) not null,
    constraint friends_accounts_user_id_fk
        foreign key (user_id) references submaline.accounts (user_id)
            on delete cascade,
    constraint user_id
        unique (user_id, friend_user_id)
);

create table submaline.blocks
(
    id              int auto_increment
        primary key,
    user_id         varchar(128) not null,
    blocked_user_id varchar(128) not null,
    constraint blocks_accounts_user_id_fk
        foreign key (user_id) references submaline.accounts (user_id)
            on delete cascade,
    constraint user_id
        unique (user_id, blocked_user_id)
);


/*  */
create table submaline.messages
(
    message_id   varchar(23)                               not null
        primary key,
    `from`       varchar(128)                              not null,
    `to`         varchar(260)                              not null,
    content_type int                                       not null,
    text         text                         default ''   not null,
    metadata     longtext collate utf8mb4_bin default '{}' not null,
    constraint metadata
        check (json_valid(`metadata`))
);

/* */
create table submaline.groups
(
    group_id        varchar(23)                               not null primary key,
    display_name    varchar(30)                  default ''   not null,
    icon_path       varchar(50)                  default ''   not null,
    `description`   text                         default ''   not null,
    metadata        longtext collate utf8mb4_bin default '{}' not null,
    creator_user_id varchar(128)                              not null,
    created_at      datetime                     DEFAULT CURRENT_TIMESTAMP,
    constraint metadata
        check (json_valid(`metadata`))
);

/* */
create table submaline.group_members
(
    id             int auto_increment
        primary key,
    group_id       varchar(23)  not null,
    member_user_id varchar(128) not null,
    constraint group_members_groups_group_id_fk
        foreign key (group_id) references submaline.groups (group_id)
            on delete cascade,
    constraint group_id
        unique (group_id, member_user_id)
);

/* */
create table submaline.group_invitees
(
    id             int auto_increment
        primary key,
    group_id       varchar(23)  not null,
    invitee_user_id varchar(128) not null,
    constraint group_invitees_groups_group_id_fk
        foreign key (group_id) references submaline.groups (group_id)
            on delete cascade,
    constraint group_id
        unique (group_id, invitee_user_id)
);

/*  */
create table submaline.operations
(
    operation_id bigint       not null
        primary key,
    type         int          not null,
    source       varchar(128) null,
    param1       varchar(260),
    param2       varchar(260),
    param3       varchar(260),
    created_at   datetime DEFAULT CURRENT_TIMESTAMP
);

/*  */
create table submaline.operation_destinations
(
    id                  int auto_increment
        primary key,
    operation_id        bigint       not null,
    destination_user_id varchar(128) not null,
    constraint operation_id
        unique (operation_id, destination_user_id)
);
