# frozen_string_literal: true

Mongoid::Document.include(GlobalID::Identification)
Mongoid::Association::Proxy.include(GlobalID::Identification)