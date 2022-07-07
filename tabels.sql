/*  */
create table submaline.accounts
(
    user_id varchar(128)  not null
        primary key,
    email   varchar(320) not null,
    constraint accounts_email_uindex
        unique (email)
);

/*  */
create table submaline.user_names
(
    user_id   varchar(128) not null,
    user_name varchar(20) not null,
    constraint user_names_user_name_uindex
        unique (user_name)
);

/*  */
create table submaline.profiles
(
    user_id        varchar(128)                                    null,
    display_name   varchar(30)                  default '' not null,
    icon_path      varchar(50)                  default '' not null,
    status_message varchar(50)                  default ''        not null,
    metadata       longtext collate utf8mb4_bin default '{}'      not null,
    constraint profiles_accounts_user_id_fk
        foreign key (user_id) references submaline.accounts (user_id)
            on delete cascade,
    constraint metadata
        check (json_valid(`metadata`))
);

/*  */
create table submaline.settings
(
    user_id varchar(128)                               not null,
    setting longtext collate utf8mb4_bin default '{}' not null,
    constraint settings_accounts_user_id_fk
        foreign key (user_id) references submaline.accounts (user_id)
            on delete cascade,
    constraint setting
        check (json_valid(`setting`))
);


/*  */
create table submaline.messages
(
    id   varchar(23)                               not null
        primary key,
    `from`       varchar(128)                               not null,
    `to`         varchar(260)                               not null,
    content_type int                                       not null,
    text         text                         default ''   not null,
    metadata     longtext collate utf8mb4_bin default '{}' not null,
    constraint metadata
        check (json_valid(`metadata`))
);

/*  */
create table submaline.operations
(
    id     bigint       not null
        primary key,
    type   int          not null,
    source varchar(128) null,
    param1 varchar(260),
    param2 varchar(260),
    param3 varchar(260),
    created_at datetime DEFAULT CURRENT_TIMESTAMP,
    constraint operations_accounts_user_id_fk
        foreign key (source) references submaline.accounts (user_id)
            on delete set null
);

/*  */
create table submaline.operation_destinations
(
    id                  int auto_increment
        primary key,
    operation_id        bigint       not null,
    destination_user_id varchar(128) not null,
    constraint operation_id
        unique (operation_id, destination_user_id),
    constraint operation_destinations_accounts_user_id_fk
        foreign key (destination_user_id) references submaline.accounts (user_id),
    constraint operation_destinations_operations_id_fk
        foreign key (operation_id) references submaline.operations (id)
);
