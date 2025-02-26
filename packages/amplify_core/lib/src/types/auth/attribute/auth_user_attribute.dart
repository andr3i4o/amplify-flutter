/*
 * Copyright 2021 Amazon.com, Inc. or its affiliates. All Rights Reserved.
 *
 * Licensed under the Apache License, Version 2.0 (the "License").
 * You may not use this file except in compliance with the License.
 * A copy of the License is located at
 *
 *  http://aws.amazon.com/apache2.0
 *
 * or in the "license" file accompanying this file. This file is distributed
 * on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either
 * express or implied. See the License for the specific language governing
 * permissions and limitations under the License.
 */

import 'package:amplify_core/amplify_core.dart';
import 'package:meta/meta.dart';

@immutable
class AuthUserAttribute {
  final UserAttributeKey userAttributeKey;
  final String value;

  /// Creates an object that holds the key and value for a user attribute.
  const AuthUserAttribute({
    required this.userAttributeKey,
    required this.value,
  });

  Map<String, Object?> serializeAsMap() {
    final Map<String, Object?> pendingRequest = <String, dynamic>{};
    pendingRequest['userAttributeKey'] = userAttributeKey.key;
    pendingRequest['value'] = value;
    return pendingRequest;
  }

  @override
  bool operator ==(Object other) =>
      other is AuthUserAttribute &&
      userAttributeKey == other.userAttributeKey &&
      value == other.value;

  @override
  int get hashCode => Object.hash(userAttributeKey.hashCode, value.hashCode);

  @override
  String toString() =>
      'AuthUserAttribute(userAttributeKey=$userAttributeKey, value=$value)';
}
