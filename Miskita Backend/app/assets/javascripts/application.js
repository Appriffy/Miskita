jQuery(function() {
    let current_time = new Date();
    let zoneOffset = current_time.getTimezoneOffset();
    document.cookie='timezone='+zoneOffset;
  });
