CREATE DATABASE TicketDB;
GO

USE TicketDB;
GO

-- roles
create table roles (
    Id int primary key identity(1,1),
    Name nvarchar(50) not null,
    constraint uq_roles_name unique (name),
    constraint ck_roles_name check (name in ('MANAGER', 'SUPPORT', 'USER'))
);
go

-- users
create table users (
    Id int primary key identity(1,1),
    Name nvarchar(255) not null,
    Email nvarchar(255) not null,
    PasswordHash nvarchar(255) not null,
    RoleId int not null,
    CreatedAt datetime2 not null default sysdatetime(),
    constraint uq_users_email unique (email),
    constraint fk_users_roles foreign key (RoleId) references roles(Id)
);
go

-- tickets
create table tickets (
    Id int primary key identity(1,1),
    Title nvarchar(255) not null,
    Description nvarchar(max) not null,
    Status nvarchar(20) not null default 'OPEN',
    Priority nvarchar(10) not null default 'MEDIUM',
    CreatedBy int not null,
    AssignedTo int null,
    CreatedAt datetime2 not null default sysdatetime(),
    constraint ck_tickets_status check (status in ('OPEN', 'IN_PROGRESS', 'RESOLVED', 'CLOSED')),
    constraint ck_tickets_priority check (priority in ('LOW', 'MEDIUM', 'HIGH')),
    constraint fk_tickets_createdby foreign key (CreatedBy) references users(Id),
    constraint fk_tickets_assignedto foreign key (AssignedTo) references users(Id)
);
go

-- ticketcomments
create table ticketcomments (
    Id int primary key identity(1,1),
    TicketId int not null,
    UserId int not null,
    Comment nvarchar(max) not null,
    CreatedAt datetime2 not null default sysdatetime(),
    constraint fk_ticketcomments_tickets foreign key (TicketId) references tickets(Id) on delete cascade,
    constraint fk_ticketcomments_users foreign key (UserId) references users(Id)
);
go

-- ticketstatuslogs
create table ticketstatuslogs (
    Id int primary key identity(1,1),
    TicketId int not null,
    OldStatus nvarchar(20) not null,
    NewStatus nvarchar(20) not null,
    ChangedBy int not null,
    ChangedAt datetime2 not null default sysdatetime(),
    constraint ck_ticketstatuslogs_oldstatus check (OldStatus in ('OPEN', 'IN_PROGRESS', 'RESOLVED', 'CLOSED')),
    constraint ck_ticketstatuslogs_newstatus check (NewStatus in ('OPEN', 'IN_PROGRESS', 'RESOLVED', 'CLOSED')),
    constraint fk_ticketstatuslogs_tickets foreign key (TicketId) references tickets(Id) on delete cascade,
    constraint fk_ticketstatuslogs_users foreign key (ChangedBy) references users(Id)
);
go


-- insert
insert into roles values ('MANAGER'),('SUPPORT'),('USER');
go

insert into users (name, email, passwordhash, roleid)
values (
    'Admin Manager',
    'manager@example.com',
    '$2a$11$GCwPm5IknRJki4xZ0Ue3COEM0si7mSVXgB0Q/lXeGUA8ibAo7K2zq', --Manager@123
    1
);
go

select * from roles;
select * from users;
go
