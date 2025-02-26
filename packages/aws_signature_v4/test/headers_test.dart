// Copyright 2022 Amazon.com, Inc. or its affiliates. All Rights Reserved.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

import 'dart:convert';

import 'package:aws_common/aws_common.dart';
import 'package:aws_signature_v4/aws_signature_v4.dart';
import 'package:test/test.dart';

import 'common.dart';

void main() {
  group('Headers', () {
    const signer = AWSSigV4Signer(
      credentialsProvider: AWSCredentialsProvider(dummyCredentials),
    );
    final request = AWSHttpRequest.post(
      Uri.https('example.com', '/'),
      body: utf8.encode('hello'),
      headers: const {
        AWSHeaders.contentLength: '5',
      },
    );
    final signedRequest = signer.signSync(
      request,
      credentialScope: dummyCredentialScope,
    );
    final signedHeaders = CaseInsensitiveMap(
      signedRequest.canonicalRequest.canonicalHeaders,
    );
    final sentHeaders = signedRequest.headers;

    test('Host, Content-Length unset by signer (web)', () {
      expect(
        signedHeaders,
        contains(AWSHeaders.host),
      );
      expect(
        signedHeaders,
        contains(AWSHeaders.contentLength),
      );
      expect(
        sentHeaders,
        isNot(contains(AWSHeaders.host)),
      );
      expect(
        sentHeaders,
        isNot(contains(AWSHeaders.contentLength)),
      );
    }, testOn: 'browser');

    test('X-Amz-User-Agent header is included', () {
      expect(
        sentHeaders,
        containsPair(AWSHeaders.amzUserAgent, contains('aws-sigv4-dart')),
      );
      expect(
        sentHeaders,
        isNot(contains(AWSHeaders.userAgent)),
      );
      expect(
        signedHeaders,
        contains(AWSHeaders.amzUserAgent),
      );
      expect(
        signedHeaders,
        isNot(contains(AWSHeaders.userAgent)),
      );
    }, testOn: 'browser');

    test('Host, Content-Length set by signer (vm)', () {
      expect(
        signedHeaders,
        contains(AWSHeaders.host),
      );
      expect(
        signedHeaders,
        contains(AWSHeaders.contentLength),
      );
      expect(
        sentHeaders,
        contains(AWSHeaders.host),
      );
      expect(
        sentHeaders,
        contains(AWSHeaders.contentLength),
      );
    }, testOn: 'vm');

    test('User-Agent header is included', () {
      expect(
        sentHeaders,
        isNot(contains(AWSHeaders.amzUserAgent)),
      );
      expect(
        sentHeaders,
        containsPair(AWSHeaders.userAgent, contains('aws-sigv4-dart')),
      );
      expect(
        signedHeaders,
        isNot(contains(AWSHeaders.amzUserAgent)),
      );
      expect(
        signedHeaders,
        isNot(contains(AWSHeaders.userAgent)),
        reason: 'User-Agent header is never signed',
      );
    }, testOn: 'vm');
  });
}
